# crossplane-function-cue

**This is now archived and has been contributed [upstream](https://github.com/crossplane-contrib/function-cue)**

A crossplane function that runs cue scripts for composing resources.

#### Build status

![go build](https://github.com/elastic/crossplane-function-cue/actions/workflows/go-build.yaml/badge.svg?branch=main)
![docker build-push](https://github.com/elastic/crossplane-function-cue/actions/workflows/docker-build-push.yaml/badge.svg?branch=main)
![check notices](https://github.com/elastic/crossplane-function-cue/actions/workflows/check-notices.yaml/badge.svg?branch=main)
![check license headers](https://github.com/elastic/crossplane-function-cue/actions/workflows/check-license-headers.yaml/badge.svg?branch=main)

[![Go Report Card](https://goreportcard.com/badge/github.com/elastic/crossplane-function-cue)](https://goreportcard.com/report/github.com/elastic/crossplane-function-cue)
[![Go Coverage](https://github.com/elastic/crossplane-function-cue/wiki/coverage.svg)](https://raw.githack.com/wiki/elastic/crossplane-function-cue/coverage.html)

## Building

```shell
$ make # generate input, compile, test, lint
$ make docker # build docker image
$ make docker-push # push docker image
```

## Function interface

You define the function as follows:
```yaml
apiVersion: pkg.crossplane.io/v1beta1
kind: Function
metadata:
  name: fn-cue
spec:
  package: gotwarlost/crossplane-function-cue:latest
  packagePullPolicy: Always
```

and reference it in a composition as follows:

```yaml
  pipeline:
    - step: run cue composition
      functionRef:
        name: fn-cue
      input:
        apiVersion: fn-cue/v1    # can be anything
        kind: CueFunctionParams  # can be anything
        spec:
          source: Inline         # only Inline is supported for now
          script: |              # text of cue program
            text of cue program
          # show inputs and outputs for the composition in the pod log in pretty format
          debug: true  
```

The full spec of the input object can be [found here](pkg/input/v1beta1/input.go)

## The Go code

The program `xp-function-cue` provides the following subcommands:

* `server` - used by the docker image to run the function implementation
* `openapi` - utility that converts a cue type into an openAPI schema that has self-contained types.
* `package-script` - utility that takes a cue package and turns it into a self-contained cue script of the form:

```
  "_script": "script text"
```

* `cue-test` - utility to unit test your cue implementation using inputs from various stages of the composition lifecycle.

## The cue script

The cue script is a single self-contained program(*) that you provide which is compiled after it is appended with 
additional cue code that looks like the following:

```
  "#request": <input-object>
```

The &lt;input-object&gt; is the same as the [RunFunctionRequest](https://github.com/crossplane/crossplane/blob/bf5c51e6dfdde4c45a0d50c31c23147f5050e9dd/apis/apiextensions/fn/proto/v1beta1/run_function.proto#L33) 
message in JSON form, except it only contains the `observed`, `desired`, and `context` attributes. 
It does **not** have the `meta` or the `input` attributes.

The cue script is expected to return a response that is the JSON equivalent of the [RunFunctionResponse](https://github.com/crossplane/crossplane/blob/bf5c51e6dfdde4c45a0d50c31c23147f5050e9dd/apis/apiextensions/fn/proto/v1beta1/run_function.proto#L66)
message containing the desired state and optionally context variables to be set for the pipeline. 
The function runner will selectively update its internal desired state with the
returned resources. If a composite is returned, it will also be set in the response. You will only typically include the
`status` of the composite resource.

(*) Note that it is not necessary for the cue source code to be in a single file. It can span multiple files in a single
package and depend on other packages. You use the `package-script` sub-command of `xp-function-cue` to create the
self-contained script. This, in turn, uses `cue def --inline-imports` under the covers.

The names of the request and response objects are configurable in the function input.

See the [example implementation](examples/simple/platform/compositions/xs3bucket/runtime/) to get a sense of 
how the composition works. A detailed walkthrough can be found in the [README](examples/simple/) for the example.

## License

The code is distributed under the Apache 2 license. See the [LICENSE](LICENSE) file for details.

