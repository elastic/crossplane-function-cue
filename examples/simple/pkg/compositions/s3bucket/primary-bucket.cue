package s3bucket

response: desired: resources: main: resource: {
	apiVersion: "s3.aws.upbound.io/v1beta1"
	kind:       "Bucket"
	metadata: {
		name: compName
	}
	spec: forProvider: {
		forceDestroy: true
		region:       composite.spec.parameters.region
		tags:         tagValues
	}
}

// set the primary endpoint on the status if found
{
	let p = #request.observed.resources.main.resource.status.atProvider.bucketRegionalDomainName
	if p != _|_ {
		response: desired: composite: resource: status: primaryEndpoint: p
	}
}
