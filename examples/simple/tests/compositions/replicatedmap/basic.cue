@if(basic)
package replicatedmap

import (
	k8sCore "k8s.io/api/core/v1"
)

request: {
	context: "apiextensions.crossplane.io/environment": {
		apiVersion: "internal.crossplane.io/v1alpha1"
		kind:       "Environment"
	}
	desired: {}
	observed: composite: resource: {
		apiVersion: "simple.cuefn.example.com/v1alpha1"
		kind:       "XReplicatedMap"
		metadata: {
			finalizers: [
				"composite.apiextensions.crossplane.io",
			]
			generateName: "map1-"
			labels: {
				"crossplane.io/claim-name":      "map1"
				"crossplane.io/claim-namespace": "claims"
				"crossplane.io/composite":       "map1-mwtrw"
			}
			name: "map1-mwtrw"
		}
		spec: {
			claimRef: {
				apiVersion: "simple.cuefn.example.com/v1alpha1"
				kind:       "ReplicatedMap"
				name:       "map1"
				namespace:  "claims"
			}
			compositionRef: name:         "xreplicatedmaps.simple.cuefn.example.com"
			compositionRevisionRef: name: "xreplicatedmaps.simple.cuefn.example.com-f5c46a5"
			compositionUpdatePolicy: "Automatic"
			parameters: {
				data: meaning_of_life: "42"
				namespaces: [
					"foo",
					"bar",
					"baz",
				]
			}
		}
	}
}

response: desired: resources: config_map_bar: resource: spec: forProvider: manifest: k8sCore.#ConfigMap

{
	response: desired: resources: {
		config_map_bar: resource: {
			apiVersion: "kubernetes.crossplane.io/v1alpha2"
			kind:       "Object"
			metadata: name: "cm-map1-mwtrw-bar"
			spec: forProvider: manifest: {
				apiVersion: "v1"
				data: meaning_of_life: "42"
				kind: "ConfigMap"
				metadata: {
					labels: {
						"crossplane.io/claim-name":      "map1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "map1-mwtrw"
					}
					name:      "map1"
					namespace: "bar"
				}
			}
		}
		config_map_baz: resource: {
			apiVersion: "kubernetes.crossplane.io/v1alpha2"
			kind:       "Object"
			metadata: name: "cm-map1-mwtrw-baz"
			spec: forProvider: manifest: {
				apiVersion: "v1"
				data: meaning_of_life: "42"
				kind: "ConfigMap"
				metadata: {
					labels: {
						"crossplane.io/claim-name":      "map1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "map1-mwtrw"
					}
					name:      "map1"
					namespace: "baz"
				}
			}
		}
		config_map_foo: resource: {
			apiVersion: "kubernetes.crossplane.io/v1alpha2"
			kind:       "Object"
			metadata: name: "cm-map1-mwtrw-foo"
			spec: forProvider: manifest: {
				apiVersion: "v1"
				data: meaning_of_life: "42"
				kind: "ConfigMap"
				metadata: {
					labels: {
						"crossplane.io/claim-name":      "map1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "map1-mwtrw"
					}
					name:      "map1"
					namespace: "foo"
				}
			}
		}
	}
}
