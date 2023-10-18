package resources

import (
	xp "github.com/crossplane/crossplane/apis/pkg/v1beta1"
	gvk "cue-functions.io/examples/simple/shared/gvk"
)

// defines the function definition for the crossplane functions
_objects: cuefn: xp.#Function & {
	apiVersion: "pkg.crossplane.io/v1beta1"
	kind:       "Function"
	metadata: {
		name: gvk.function.name
	}
	spec: {
		package:           gvk.function.image
		packagePullPolicy: "Always"
	}
}
