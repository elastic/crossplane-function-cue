package s3bucket

response: desired: resources: {
	let S = spec
	for s in suffixes {
		let bucketName = "bucket\(s)"
		(bucketName): {
			resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: {
					name: "\(compName)\(s)"
				}
				spec: forProvider: {
					forceDestroy: true
					region:       S.parameters.region
					tags:         tagValues
				}
			}
		}
	}
}

let endpoints0 = [
	for s in suffixes {
		let bucketName = "bucket\(s)"
		[
			if request.observed.resources[bucketName].resource.status.atProvider.bucketRegionalDomainName != _|_ {
				request.observed.resources[bucketName].resource.status.atProvider.bucketRegionalDomainName
			},
			"unknown",
		][0]
	},
]

let endpoints1 = [for e in endpoints0 if e != "unknown" {e}]

// only render additional endpoints if all of them are available since it is an ordered list
// that matches the suffix list
if len(endpoints1) == len(suffixes) && len(suffixes) > 0 {
	response: desired: composite: resource: status: additionalEndpoints: endpoints1
}
