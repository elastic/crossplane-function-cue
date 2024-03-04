package replicatedmap

for ns in _params.namespaces {
	resources: "config_map_\(ns)": resource: {
		apiVersion: "kubernetes.crossplane.io/v1alpha2"
		kind:       "Object"
		metadata: name: "cm-\(_compName)-\(ns)"

		spec: forProvider: manifest: {
			apiVersion: "v1"
			kind:       "ConfigMap"
			metadata: {
				namespace: ns
				name:      _configMapName
				labels:    _composite.metadata.labels
			}
			data: _params.data
		}
	}
}
