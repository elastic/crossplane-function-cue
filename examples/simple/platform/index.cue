package resources

import (
	"list"
	"cue-functions.io/examples/simple/platform/compositions"
)

_base: list.FlattenN([
	for _, v in _objects {[v]},
], 1)

resources: list.Concat([
	_base,
	compositions.resources,
])
