package s3bucket

resources: {
	for s in _suffixes {
		let bucketName = "bucket\(s)"
		(bucketName): {
			resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: {
					name: "\(_compName)\(s)"
				}
				spec: forProvider: {
					forceDestroy: true
					region:       _spec.parameters.region
					tags:         _tags
				}
			}
		}
	}
}

let endpoints0 = [
	for s in _suffixes {
		let bucketName = "bucket\(s)"
		[
			if _request.observed.resources[bucketName].resource.status.atProvider.bucketRegionalDomainName != _|_ {
				_request.observed.resources[bucketName].resource.status.atProvider.bucketRegionalDomainName
			},
			"unknown",
		][0]
	},
]

let endpoints1 = [for e in endpoints0 if e != "unknown" {e}]

// only render additional endpoints if all of them are available since it is an ordered list
// that matches the suffix list
if len(endpoints1) == len(_suffixes) && len(_suffixes) > 0 {
	composite: resource: status: additionalEndpoints: endpoints1
}
