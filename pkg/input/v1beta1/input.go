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

// Package v1beta1 contains the input type for the cue function runner.
// +kubebuilder:object:generate=true
// +groupName=cue.fn.crossplane.io
// +versionName=v1beta1
package v1beta1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// This isn't a custom resource, in the sense that we never install its CRD.
// It is a KRM-like object, so we generate a CRD to describe its schema.

// A ScriptSource is a source from which a script can be loaded.
type ScriptSource string

// Supported script sources.
const (
	// ScriptSourceInline specifies a script inline.
	ScriptSourceInline ScriptSource = "Inline"
)

// CueInputSpec is the spec for running a cue script.
type CueInputSpec struct {
	// Source of this script. Currently only Inline is supported.
	// +kubebuilder:validation:Enum=Inline
	// +kubebuilder:default=Inline
	Source ScriptSource `json:"source"`
	// Script specifies an inline script
	// +optional
	Script string `json:"script,omitempty"`
	// Debug prints inputs to and outputs of the cue script.
	// Inputs are pre-processed to remove typically irrelevant information like
	// the last applied kubectl annotation, managed fields etc.
	// Objects are displayed in compact cue format. (the equivalent of `cue fmt -s`)
	// +optional
	Debug bool `json:"debug,omitempty"`
	// DebugRaw disables the pre-processing of inputs.
	// +optional
	DebugRaw bool `json:"debugRaw,omitempty"`
	// DebugScript displays the full generated script that is executed.
	// +optional
	DebugScript bool `json:"debugScript,omitempty"`
}

// CueFunctionParams can be used to provide input to the cue function runner.
// +kubebuilder:object:root=true
// +kubebuilder:storageversion
// +kubebuilder:resource:categories=crossplane
type CueFunctionParams struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	// Spec is the input spec for the function.
	Spec CueInputSpec `json:"spec"`
}
