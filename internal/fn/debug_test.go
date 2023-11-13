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
	"encoding/base64"
	"encoding/json"
	"fmt"
	"testing"

	"cuelang.org/go/cue/cuecontext"

	"github.com/ghodss/yaml"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func yaml2Object(t *testing.T, s string) any {
	var data any
	err := yaml.Unmarshal([]byte(s), &data)
	require.NoError(t, err)
	return data
}

func TestDebugRemoveNoise(t *testing.T) {
	f, err := New(Options{})
	require.NoError(t, err)
	inputYAML := `
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: foobar
    annotations:
      "kubectl.kubernetes.io/last-applied-configuration": "{}"
    managedFields: []
    creationTimestamp: "XXX"
    generation: 1204
    resourceVersion: "yyy"
    uid: "zzz"
  data:
    foo: bar
`
	cleanedYAML := `
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: foobar
    annotations: {}
  data:
    foo: bar
`
	input := yaml2Object(t, inputYAML)
	cleaned := yaml2Object(t, cleanedYAML)
	inBytes, err := json.MarshalIndent(input, "", "  ")
	require.NoError(t, err)

	t.Run("re-serialize clean", func(t *testing.T) {
		out, err := f.reserialize(inBytes, false)
		require.NoError(t, err)
		actual := yaml2Object(t, string(out))
		assert.EqualValues(t, cleaned, actual)
	})

	t.Run("re-serialize cue", func(t *testing.T) {
		cueString := f.getDebugString(inBytes, false)
		cc := cuecontext.New()
		val := cc.CompileString(cueString)
		require.NoError(t, val.Err())
		b, err := val.MarshalJSON()
		require.NoError(t, err)
		actual := yaml2Object(t, string(b))
		assert.EqualValues(t, cleaned, actual)
	})

	t.Run("re-serialize raw", func(t *testing.T) {
		out, err := f.reserialize(inBytes, true)
		require.NoError(t, err)
		actual := yaml2Object(t, string(out))
		assert.EqualValues(t, input, actual)
	})

	t.Run("re-serialize cue raw", func(t *testing.T) {
		cueString := f.getDebugString(inBytes, true)
		cc := cuecontext.New()
		val := cc.CompileString(cueString)
		require.NoError(t, val.Err())
		b, err := val.MarshalJSON()
		require.NoError(t, err)
		actual := yaml2Object(t, string(b))
		assert.EqualValues(t, input, actual)
	})
}

func TestDebugRemoveConnectionDetails(t *testing.T) {
	f, err := New(Options{})
	require.NoError(t, err)
	inputYAML := `
- resource:
    resource: 
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: foobar
      data:
        foo: bar
    connectionDetails:
      secret1: super-secret
      secret2: even-more-secret
`
	redacted := []byte(base64.StdEncoding.EncodeToString([]byte("<redacted>")))
	cleanedYAML := fmt.Sprintf(`
- resource:
    resource: 
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: foobar
      data:
        foo: bar
    connectionDetails:
      secret1: %s
      secret2: %s
`, redacted, redacted)
	input := yaml2Object(t, inputYAML)
	cleaned := yaml2Object(t, cleanedYAML)
	inBytes, err := json.MarshalIndent(input, "", "  ")
	require.NoError(t, err)
	out, err := f.reserialize(inBytes, false)
	require.NoError(t, err)
	actual := yaml2Object(t, string(out))
	assert.EqualValues(t, cleaned, actual)
}

func TestDebugBadJSON(t *testing.T) {
	f, err := New(Options{})
	require.NoError(t, err)
	s := f.getDebugString([]byte("{ foo:"), true)
	assert.EqualValues(t, "{ foo:", s)
}
