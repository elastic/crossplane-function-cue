package replicatedmap

_request: {...}

_composite: _request.observed.composite.resource
_compName:  _composite.metadata.name
_params:    _composite.spec.parameters

_configMapName: [
		if _params.name != _|_ {_params.name},
		_composite.metadata.labels["crossplane.io/claim-name"],
][0]
