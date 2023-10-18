package runtime

resources: {
	main: resource: {
		apiVersion: "s3.aws.upbound.io/v1beta1"
		kind:       "Bucket"
		metadata: {
			name: _composite.metadata.name
		}
		spec: forProvider: {
			forceDestroy: true
			region:       _spec.parameters.region
			tags:         _tags
		}
	}

	// set its status if we see the aws resource is ready
	let conditions = (#listWithDefault & {
		in: _request.observed.resources.main.resource.status.conditions
		def: {type: "Ready", status: "Unknown"}
	}).out
	let readyValue = [ for x in conditions if x.type == "Ready" {x.status}][0]
	main: ready: [
			if readyValue == "True" {ready:  "READY_TRUE"},
			if readyValue == "False" {ready: "READY_FALSE"},
			{ready:                          "READY_UNSPECIFIED"},
	][0].ready
}

// set the primary endpoint on the status if found
if _request.observed.resources.main.resource.status.atProvider.bucketRegionalDomainName != _|_ {
	composite: resource: {
		status: {
			primaryEndpoint: _request.observed.resources.main.resource.status.atProvider.bucketRegionalDomainName
		}
	}
}
