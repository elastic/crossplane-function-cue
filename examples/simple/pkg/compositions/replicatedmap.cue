package compositions

import (
	xp "github.com/crossplane/crossplane/apis/apiextensions/v1"
	//fn "github.com/elastic/crossplane-function-cue/pkg/input/v1beta1"
	schemas "cue-functions.io/examples/simple/zz_generated/schemas"
	//scripts "cue-functions.io/examples/simple/zz_generated/scripts"
)

let version = "v1alpha1"
let pluralName = "xreplicatedmaps"
let xrdKind = "XReplicatedMap"
let groupName = "simple.cuefn.example.com"

_xrds: replicatedMap: xp.#CompositeResourceDefinition & {
	apiVersion: "apiextensions.crossplane.io/v1"
	kind:       "CompositeResourceDefinition"
	metadata: {
		name: "\(pluralName).\(groupName)"
	}

	spec: {
		group: groupName
		names: {
			kind:   xrdKind
			plural: pluralName
		}
		claimNames: {
			kind:   "ReplicatedMap"
			plural: "replicatedmaps"
		}
		versions: [{
			name:          version
			served:        true
			referenceable: true
			schema: openAPIV3Schema: schemas.components.schemas.ReplicatedMapV1alpha1
		}]
	}
}
