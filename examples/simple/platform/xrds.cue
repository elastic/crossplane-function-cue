package platform

import (
	xp "github.com/crossplane/crossplane/apis/apiextensions/v1"
	schemas "cue-functions.io/examples/simple/shared/schemas"
	gvk "cue-functions.io/examples/simple/shared/gvk"
)

_objects: xs3Bucket: xp.#CompositeResourceDefinition & {
	let b = gvk.s3Bucket
	apiVersion: "apiextensions.crossplane.io/v1"
	kind:       "CompositeResourceDefinition"
	metadata: {
		name: "\(b.xrd.plural).\(gvk.group)"
	}
	spec: {
		group: gvk.group
		names: {
			kind:   b.xrd.kind
			plural: b.xrd.plural
		}
		claimNames: {
			kind:   b.claim.kind
			plural: b.claim.plural
		}
		versions: [
			{
				name:          b.version
				served:        true
				referenceable: true
				additionalPrinterColumns: [
					{
						jsonPath: ".status.primaryEndpoint"
						name:     "primary endpoint"
						type:     "string"
					},
					{
						jsonPath: ".status.iamPolicyARN"
						name:     "iam policy ARN"
						type:     "string"
					},
				]
				// just refer to the schema created from the api package
				schema: openAPIV3Schema: schemas.components.schemas.S3BucketV1alpha1
			},
		]
	}
}
