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
	"bytes"
	"encoding/json"
	"fmt"

	"cuelang.org/go/cue/format"
	"cuelang.org/go/encoding/openapi"
	"github.com/pkg/errors"
)

// GenerateOpenAPISchema generates an openapi schema using the contents of the supplied directory
// and returns it prefixing it with a package declaration for the supplied package.
func GenerateOpenAPISchema(dir, pkg string) ([]byte, error) {
	iv, err := loadSingleInstanceValue(dir, nil)
	if err != nil {
		return nil, err
	}
	b, err := openapi.Gen(iv.value, &openapi.Config{
		Info: map[string]any{
			"title":       "XRD schemas",
			"description": fmt.Sprintf("Generated by %s, DO NOT EDIT", generator),
			"version":     "0.1.0",
		},
		SelfContained:    true,
		ExpandReferences: true,
	})
	if err != nil {
		return nil, errors.Wrap(err, "generate openAPI")
	}

	var out bytes.Buffer
	if pkg != "" {
		_, _ = out.Write([]byte(fmt.Sprintf("package %s\n\n", pkg)))
	}
	err = json.Indent(&out, b, "", "  ")
	if err != nil {
		return nil, errors.Wrap(err, "write output")
	}
	ret, err := format.Source(out.Bytes(), format.Simplify())
	if err != nil {
		return nil, errors.Wrap(err, "cue format")
	}
	return ret, nil
}
