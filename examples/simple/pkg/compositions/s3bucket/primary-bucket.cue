package s3bucket

resources: main: resource: {
	apiVersion: "s3.aws.upbound.io/v1beta1"
	kind:       "Bucket"
	metadata: {
		name: _compName
	}
	spec: forProvider: {
		forceDestroy: true
		region:       _spec.parameters.region
		tags:         _tags
	}
}

// set the primary endpoint on the status if found
{
	let p = _request.observed.resources.main.resource.status.atProvider.bucketRegionalDomainName
	if p != _|_ {
		composite: resource: status: primaryEndpoint: p
	}
}
