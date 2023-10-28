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
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func getOutput() (_ *bytes.Buffer, reset func()) {
	old := TestOutput
	buf := bytes.NewBuffer(nil)
	TestOutput = buf
	return buf, func() {
		TestOutput = old
	}
}

func TestTester(t *testing.T) {
	buf, reset := getOutput()
	defer reset()
	tester, err := NewTester(TestConfig{
		Package: "./testdata/runtime",
	})
	require.NoError(t, err)
	err = tester.Run()
	expected := `
running test tags: correct, incorrect
> run test "correct"
PASS correct
> run test "incorrect"
diffs found:
--- expected
+++ actual
@@ -2,5 +2,5 @@
   main:
     resource:
       bar: baz
-      foo: bar
+      foo: foo2
FAIL incorrect: expected did not match actual
`
	require.Error(t, err)
	assert.Equal(t, "1 of 2 tests had errors", err.Error())
	assert.Equal(t, strings.TrimSpace(expected), strings.TrimSpace(buf.String()))
}

func TestTesterBadTag(t *testing.T) {
	buf, reset := getOutput()
	defer reset()
	tester, err := NewTester(TestConfig{
		Package:  "./testdata/runtime",
		TestTags: []string{"foo"},
	})
	require.NoError(t, err)
	err = tester.Run()
	require.Error(t, err)
	assert.Equal(t, "1 of 1 tests had errors", err.Error())
	assert.Contains(t, buf.String(), "FAIL foo: evaluate expected: load instance: build constraints exclude all CUE files in ./testdata/runtime/tests")
}

func TestTesterAllPass(t *testing.T) {
	buf, reset := getOutput()
	defer reset()
	tester, err := NewTester(TestConfig{
		Package:  "./testdata/runtime",
		TestTags: []string{"correct"},
	})
	require.NoError(t, err)
	err = tester.Run()
	require.NoError(t, err)
	assert.Contains(t, buf.String(), "PASS correct")
}
