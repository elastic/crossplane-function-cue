package user

_claimsNamespace: string | *"claims" @tag(namespace)

s3_resources: [
	_objects.claimNamespace,
	_objects.s3Bucket,
]

map_resources: [
	_objects.claimNamespace,
	_objects.replicatedMap,
] + _objects.replicatedNamespaces
