package replicatedmap

#request: {...}

composite: #request.observed.composite.resource
compName:  composite.metadata.name
params:    composite.spec.parameters

configMapName: [
		if params.name != _|_ {params.name},
		composite.metadata.labels["crossplane.io/claim-name"],
][0]
