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
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestPackageScript(t *testing.T) {
	fn := chdirCueRoot(t)
	defer fn()
	script, err := PackageScript("./runtime", PackageScriptOpts{OutputPackage: "composition", Format: FormatCue})
	require.NoError(t, err)
	assert.Contains(t, string(script), "package composition\n")
	assert.Contains(t, string(script), `_script: "`)

	script, err = PackageScript("./runtime", PackageScriptOpts{OutputPackage: "composition", Format: FormatRaw})
	require.NoError(t, err)
	assert.NotContains(t, string(script), "package composition\n")
	assert.NotContains(t, string(script), `_script: "`)
}
