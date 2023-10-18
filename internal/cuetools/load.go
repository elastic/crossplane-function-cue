// Licensed to Elasticsearch B.V. under one or more contributor
// license agreements. See the NOTICE file distributed with
// this work for additional information regarding copyright
// ownership. Elasticsearch B.V. licenses this file to you under
// the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

package cuetools

import (
	"fmt"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/build"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"
	"github.com/pkg/errors"
)

type instanceValue struct {
	instance *build.Instance
	value    cue.Value
}

// loadSingleInstanceValue loads the package at the specific directory and returns the associated instance and value.
func loadSingleInstanceValue(dir string, cfg *load.Config) (*instanceValue, error) {
	configs := load.Instances([]string{dir}, cfg)
	if len(configs) != 1 {
		return nil, fmt.Errorf("expected exactly one instance, got %d", len(configs))
	}
	config := configs[0]
	if config.Err != nil {
		return nil, errors.Wrap(config.Err, "load instance")
	}
	runtime := cuecontext.New()
	val := runtime.BuildInstance(config)
	if val.Err() != nil {
		return nil, errors.Wrap(val.Err(), "build instance")
	}
	return &instanceValue{instance: config, value: val}, nil
}
