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


# Check that the Elastic license is applied to all files.

set -eu

# shellcheck disable=2086
: "${CHECK_PATH:=$(dirname $0)/../../*}" # root project directory

# shellcheck disable=SC2086
files=$(grep \
    --include=\*.go --exclude-dir=vendor --exclude-dir=hacking \
    --include=\*.sh \
    --include=Makefile \
    -L "Apache License, Version 2.0" \
    -r ${CHECK_PATH} || true)

[ "$files" != "" ] \
    && echo -e "Error: file(s) without license header:\n$files" && exit 1 \
    || exit 0