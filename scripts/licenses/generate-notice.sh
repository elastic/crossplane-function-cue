#!/usr/bin/env bash

# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# Script to generate a NOTICE file containing licence information from dependencies.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR=${SCRIPT_DIR}/../..
TEMP_DIR=$(mktemp -d)
LICENCE_DETECTOR="go.elastic.co/go-licence-detector@v0.3.0"

trap '[[ $TEMP_DIR ]] && rm -rf "$TEMP_DIR"' EXIT

get_licence_detector() {
    GOBIN="$TEMP_DIR" go install "$LICENCE_DETECTOR"
}

generate_notice() {
    (
        cd "$PROJECT_DIR"
        go mod download all
        go list -m -json all | "${TEMP_DIR}"/go-licence-detector \
            -depsTemplate="${SCRIPT_DIR}"/templates/dependencies.md.tmpl \
            -depsOut="${PROJECT_DIR}"/DEPENDENCIES.md \
            -noticeTemplate="${SCRIPT_DIR}"/templates/notice.txt.tmpl \
            -noticeOut="${PROJECT_DIR}"/NOTICE.txt \
            -overrides="${SCRIPT_DIR}"/overrides/overrides.json \
            -rules="${SCRIPT_DIR}"/rules.json \
            -includeIndirect
        go mod tidy # undo the pollution of go.sum because of go mod download all
    )
}

echo "Generating notice file (NOTICE.txt) and dependency list (DEPENDENCIES.md)"
get_licence_detector
generate_notice
