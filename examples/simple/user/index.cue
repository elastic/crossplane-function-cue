package user

import (
	"list"
)

_claimsNamespace: string | *"claims" @tag(namespace)

resources: {
	list.FlattenN([
		for _, v in _objects {[v]},
	], 1)
}
