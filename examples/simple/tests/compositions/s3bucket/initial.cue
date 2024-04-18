@if(initial)
package tests

// this is the input you can copy from the debug log of the function pod.
// The state here is the initial state of what you will typically see when the composite is first created.
#request: {
	desired: {}
	observed: composite: resource: {
		apiVersion: "simple.cuefn.example.com/v1alpha1"
		kind:       "XS3Bucket"
		metadata: {
			annotations: {}
			finalizers: [
				"composite.apiextensions.crossplane.io",
			]
			generateName: "bucket1-"
			labels: {
				"crossplane.io/claim-name":      "bucket1"
				"crossplane.io/claim-namespace": "claims"
				"crossplane.io/composite":       "bucket1-wztcs"
			}
			name: "bucket1-wztcs"
		}
		spec: {
			claimRef: {
				apiVersion: "simple.cuefn.example.com/v1alpha1"
				kind:       "S3Bucket"
				name:       "bucket1"
				namespace:  "claims"
			}
			compositionRef: name:         "xs3buckets.simple.cuefn.example.com"
			compositionRevisionRef: name: "xs3buckets.simple.cuefn.example.com-8b31f7b"
			compositionUpdatePolicy: "Automatic"
			parameters: {
				additionalSuffixes: [
					"-001",
					"-002",
				]
				prefix: "my-bucket"
				region: "eu-west-1"
			}
			resourceRefs: []
		}
		status: conditions: [
			{
				lastTransitionTime: "2023-10-15T22:35:37Z"
				reason:             "ReconcileSuccess"
				status:             "True"
				type:               "Synced"
			},
			{
				lastTransitionTime: "2023-10-15T22:35:37Z"
				reason:             "Available"
				status:             "True"
				type:               "Ready"
			},
		]
	}
}

// this is the expected output for the input above and should exactly match what the code would produce.
response: desired: resources: {
	"bucket-001": {
		resource: {
			apiVersion: "s3.aws.upbound.io/v1beta1"
			kind:       "Bucket"
			metadata: {
				name: "bucket1-wztcs-001"
			}
			spec: {
				forProvider: {
					forceDestroy: true
					region:       "eu-west-1"
					tags: {}
				}
			}
		}
	}
	main: {
		resource: {
			apiVersion: "s3.aws.upbound.io/v1beta1"
			kind:       "Bucket"
			metadata: {
				name: "bucket1-wztcs"
			}
			spec: {
				forProvider: {
					forceDestroy: true
					region:       "eu-west-1"
					tags: {}
				}
			}
		}
	}
	"bucket-002": {
		resource: {
			apiVersion: "s3.aws.upbound.io/v1beta1"
			kind:       "Bucket"
			metadata: {
				name: "bucket1-wztcs-002"
			}
			spec: {
				forProvider: {
					forceDestroy: true
					region:       "eu-west-1"
					tags: {}
				}
			}
		}
	}
}
