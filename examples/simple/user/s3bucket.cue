package user

import (
	api "cue-functions.io/examples/simple/shared/api"
	gvk "cue-functions.io/examples/simple/shared/gvk"
)

_objects: s3Bucket: {
	apiVersion: "\(gvk.group)/\(gvk.s3Bucket.version)"
	kind:       gvk.s3Bucket.claim.kind
	metadata: {
		namespace: _claimsNamespace
		name:      "bucket1"
	}
	spec: api.#S3BucketV1alpha1.spec
	spec: parameters: {
		region: "eu-west-1"
		additionalSuffixes: [ "-001", "-002"]
		tags: {
			"bucket.purpose": "test-crossplane-cue-functions"
		}
	}
}
