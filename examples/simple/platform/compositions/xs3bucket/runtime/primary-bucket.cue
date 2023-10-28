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

	main: ready: (#readyValue & {in: _request.observed.resources.main.resource.status.conditions}).out
}

// set the primary endpoint on the status if found
if _request.observed.resources.main.resource.status.atProvider.bucketRegionalDomainName != _|_ {
	composite: resource: {
		status: {
			primaryEndpoint: _request.observed.resources.main.resource.status.atProvider.bucketRegionalDomainName
		}
	}
}
