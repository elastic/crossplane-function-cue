package user

import (
	api "cue-functions.io/examples/simple/pkg/api"
)

_namespaces: ["foo", "bar", "baz"]

_objects: replicatedNamespaces: [
	for ns in _namespaces {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: name: ns
	},
]

_objects: replicatedMap: {
	apiVersion: "simple.cuefn.example.com/v1alpha1"
	kind:       "ReplicatedMap"
	metadata: {
		namespace: _claimsNamespace
		name:      "map1"
	}
	spec: api.#ReplicatedMapV1alpha1.spec
	spec: parameters: {
		data: {
			meaning_of_life: "42"
		}
		namespaces: _namespaces
	}
}
