package user

import (
	api "cue-functions.io/examples/simple/pkg/api"
)

_objects: s3Bucket: {
	apiVersion: "simple.cuefn.example.com/v1alpha1"
	kind:       "S3Bucket"
	metadata: {
		namespace: _claimsNamespace
		name:      "bucket1"
	}
	spec: api.#S3BucketV1alpha1.spec
	spec: parameters: {
		region: "eu-west-1"
		additionalSuffixes: ["-001", "-002"]
		tags: {
			"bucket.purpose": "test-crossplane-cue-functions"
		}
	}
}
