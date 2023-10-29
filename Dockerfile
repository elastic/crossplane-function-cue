FROM golang:1.21 as builder
WORKDIR /workspace
ARG ldflags="-X 'main.Version=unknown'"

# cache deps to the extent possible
COPY go.mod go.sum ./
RUN go mod download

# copy and compile code
COPY cmd/ ./cmd/
COPY internal/ ./internal/
COPY pkg/ ./pkg/
COPY package/ ./package/
COPY Makefile ./
RUN make build ldflags="${ldflags}"

FROM busybox:latest as packager
WORKDIR /package
COPY --from=builder /workspace/package/ ./

WORKDIR /output
COPY NOTICE.txt ./
COPY DEPENDENCIES.md ./
COPY LICENSE ./
COPY --from=builder /go/bin/xp-function-cue ./
RUN cat /package/crossplane.yaml >package.yaml
RUN cat /package/input/*.yaml >>package.yaml

FROM scratch as runner
WORKDIR /
COPY --from=packager /output/ /
EXPOSE 9443
ENTRYPOINT [ "/xp-function-cue", "server" ]
