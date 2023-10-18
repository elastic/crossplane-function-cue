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

			// set its status if we see the aws resource is ready
			let conditions = (#listWithDefault & {
				in: _request.observed.resources[bucketName].resource.status.conditions
				def: {type: "Ready", status: "Unknown"}
			}).out
			let readyValue = [ for x in conditions if x.type == "Ready" {x.status}][0]

			ready: [
				if readyValue == "True" {ready:  "READY_TRUE"},
				if readyValue == "False" {ready: "READY_FALSE"},
				{ready:                          "READY_UNSPECIFIED"},
			][0].ready
		}
	}
}

let endpoints = [
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

composite: resource: status: additionalEndpoints: endpoints
