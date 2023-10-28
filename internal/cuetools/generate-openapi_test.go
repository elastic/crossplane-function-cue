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
	"encoding/json"
	"strings"
	"testing"

	"gopkg.in/yaml.v3"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/parser"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestGenerateOpenAPI(t *testing.T) {
	schema, err := GenerateOpenAPISchema("./testdata/api", "schemer")
	require.NoError(t, err)
	assert.Contains(t, string(schema), "package schemer\n")
	cc := cuecontext.New()
	val := cc.CompileBytes(schema)
	require.NoError(t, val.Err())
	expr, err := parser.ParseExpr("pointer", "components.schemas.Input")
	require.NoError(t, err)
	inputSchema := cc.BuildExpr(expr, cue.Scope(val))
	require.NoError(t, inputSchema.Err())
	b, err := inputSchema.MarshalJSON()
	require.NoError(t, err)
	var data any
	err = json.Unmarshal(b, &data)
	require.NoError(t, err)
	yamlBytes, err := yaml.Marshal(data)
	require.NoError(t, err)
	assert.Equal(t, strings.TrimSpace(`
properties:
    Address:
        properties:
            City:
                type: string
            Street:
                type: string
        type: object
    Country:
        default: USA
        enum:
            - USA
            - Canada
            - Mexico
        type: string
    Name:
        type: string
required:
    - Name
    - Country
type: object
`),
		strings.TrimSpace(string(yamlBytes)))
}
