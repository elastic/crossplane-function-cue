package replicatedmap

for ns in params.namespaces {
	response: desired: resources: "config_map_\(ns)": resource: {
		apiVersion: "kubernetes.crossplane.io/v1alpha2"
		kind:       "Object"
		metadata: name: "cm-\(compName)-\(ns)"

		spec: forProvider: manifest: {
			apiVersion: "v1"
			kind:       "ConfigMap"
			metadata: {
				namespace: ns
				name:      configMapName
				labels:    composite.metadata.labels
			}
			data: params.data
		}
	}
}
