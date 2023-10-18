package user

import (
	k8sCore "k8s.io/api/core/v1"
)

_objects: claimNamespace: k8sCore.#Namespace & {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name: _claimsNamespace
	}
}
