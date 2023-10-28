package gvk

group: "simple.cuefn.example.com"

s3Bucket: {
	version: "v1alpha1"
	claim: {
		kind:   "S3Bucket"
		plural: "s3buckets"
	}
	xrd: {
		kind:   "XS3Bucket"
		plural: "xs3buckets"
	}
}

function: {
	name: "fn-cue-examples-simple"
}
