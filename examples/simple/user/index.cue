package user

_claimsNamespace: string | *"claims" @tag(namespace)

resources: {
	[for _, v in _objects {v}]
}
