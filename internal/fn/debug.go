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

package fn

import (
	"encoding/json"
	"fmt"

	"cuelang.org/go/cue/format"
)

// start debugging routines

// noise that people typically wouldn't want to see when looking at inputs.
var systemAttributes = []struct{ parent, name string }{
	{"annotations", "kubectl.kubernetes.io/last-applied-configuration"},
	{"metadata", "managedFields"},
	{"metadata", "creationTimestamp"},
	{"metadata", "generation"},
	{"metadata", "resourceVersion"},
	{"metadata", "uid"},
}

var systemAttrsLookup map[string]map[string]bool

// init reformulates system attributes as a map for easier lookup.
func init() {
	systemAttrsLookup = map[string]map[string]bool{}
	for _, attr := range systemAttributes {
		attrMap, ok := systemAttrsLookup[attr.parent]
		if !ok {
			attrMap = map[string]bool{}
			systemAttrsLookup[attr.parent] = attrMap
		}
		attrMap[attr.name] = true
	}
}

// walkDelete performs a recursive walk on the supplied object to remove system generated
// attributes.
func walkDelete(input any, parent string) {
	switch input := input.(type) {
	case []any:
		for _, v := range input {
			walkDelete(v, parent)
		}
	case map[string]any:
		attrMap := systemAttrsLookup[parent]
		for k, v := range input {
			if attrMap != nil && attrMap[k] {
				delete(input, k)
				continue
			}
			walkDelete(v, k)
		}
	}
}

func (f *Cue) reserialize(jsonBytes []byte, raw bool) ([]byte, error) {
	var input any
	err := json.Unmarshal(jsonBytes, &input)
	if err != nil {
		f.log.Info(fmt.Sprintf("JSON unmarshal error: %v", err))
		return jsonBytes, err
	}
	if !raw {
		walkDelete(input, "")
	}
	b, err := json.MarshalIndent(input, "", "  ")
	if err != nil {
		f.log.Info(fmt.Sprintf("JSON marshal error: %v", err))
		return jsonBytes, err
	}
	return b, nil
}

// getDebugString modifies the supplied JSON bytes to remove k8s and crossplane generated metadata
// and returns its serialized form as a formatted cue object for a better user experience.
// In case of any errors, it returns the input bytes as a string.
func (f *Cue) getDebugString(jsonBytes []byte, raw bool) string {
	var err error
	jsonBytes, err = f.reserialize(jsonBytes, raw)
	if err != nil {
		return string(jsonBytes)
	}
	out, err := format.Source(jsonBytes, format.Simplify(), format.TabIndent(false), format.UseSpaces(2))
	if err != nil {
		f.log.Info(fmt.Sprintf("cue formatting error: %v", err))
		return string(jsonBytes)
	}
	return string(out)
}
