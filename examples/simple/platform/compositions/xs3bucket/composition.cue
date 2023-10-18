package xs3bucket

import (
	xp "github.com/crossplane/crossplane/apis/apiextensions/v1"
	fn "github.com/elastic/crossplane-function-cue/pkg/input/v1beta1"
	gvk "cue-functions.io/examples/simple/shared/gvk"
)

composition: xp.#Composition & {
	let b = gvk.s3Bucket
	let fullName = "\(b.xrd.plural).\(gvk.group)"
	apiVersion: "apiextensions.crossplane.io/v1"
	kind:       "Composition"
	metadata: {
		name: fullName
		labels: {
			"crossplane.io/xrd": fullName
		}
	}
	spec: {
		compositeTypeRef: {
			apiVersion: "\(gvk.group)/\(b.version)"
			kind:       b.xrd.kind
		}
		resources: []
		mode: "Pipeline"
		pipeline: [
			{
				step: "run cue composition"
				functionRef: name: gvk.function.name
				input: fn.#CueFunctionParams & {
					apiVersion: "function-cue/v1"  // value does not matter
					kind:       "CueFunctionInput" // ditto
					spec: {
						source: "Inline"
						script: _script
						debug:  true
					}
				}
			},
		]
	}
}
