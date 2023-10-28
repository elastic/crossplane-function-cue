package runtime

resources: {
	for s in _suffixes {
		let bucketName = "bucket\(s)"
		"\(bucketName)": {
			resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: {
					name: "\(_composite.metadata.name)\(s)"
				}
				spec: forProvider: {
					forceDestroy: true
					region:       _spec.parameters.region
					tags:         _tags
				}
			}
			ready: (#readyValue & {in: _request.observed.resources[bucketName].resource.status.conditions}).out
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

let endpoints1 = [ for e in endpoints0 if e != "unknown" {e}]

if len(endpoints1) == len(_suffixes) && len(_suffixes) > 0 {
	composite: resource: status: additionalEndpoints: endpoints1
}
