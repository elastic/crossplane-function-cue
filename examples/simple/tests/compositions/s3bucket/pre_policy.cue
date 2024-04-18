@if(pre_policy)
package tests

import "encoding/json"

#request: {
	desired: {}
	observed: {
		composite: resource: {
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
					"crossplane.io/composite":       "bucket1-wnht2"
				}
				name: "bucket1-wnht2"
			}
			spec: {
				claimRef: {
					apiVersion: "simple.cuefn.example.com/v1alpha1"
					kind:       "S3Bucket"
					name:       "bucket1"
					namespace:  "claims"
				}
				compositionRef: name:         "xs3buckets.simple.cuefn.example.com"
				compositionRevisionRef: name: "xs3buckets.simple.cuefn.example.com-0d79443"
				compositionUpdatePolicy: "Automatic"
				parameters: {
					additionalSuffixes: [
						"-001",
						"-002",
					]
					region: "eu-west-1"
					tags: "bucket.owner": "me"
				}
				resourceRefs: [
					{
						apiVersion: "s3.aws.upbound.io/v1beta1"
						kind:       "Bucket"
						name:       "bucket1-wnht2"
					},
					{
						apiVersion: "s3.aws.upbound.io/v1beta1"
						kind:       "Bucket"
						name:       "bucket1-wnht2-001"
					},
					{
						apiVersion: "s3.aws.upbound.io/v1beta1"
						kind:       "Bucket"
						name:       "bucket1-wnht2-002"
					},
				]
			}
			status: {
				additionalEndpoints: [
					"bucket1-wnht2-001.s3.eu-west-1.amazonaws.com",
					"bucket1-wnht2-002.s3.eu-west-1.amazonaws.com",
				]
				conditions: [
					{
						lastTransitionTime: "2023-10-21T18:22:11Z"
						reason:             "ReconcileSuccess"
						status:             "True"
						type:               "Synced"
					},
					{
						lastTransitionTime: "2023-10-21T18:22:11Z"
						message:            "Unready resources: bucket-001, bucket-002, and main"
						reason:             "Creating"
						status:             "False"
						type:               "Ready"
					},
				]
				primaryEndpoint: "bucket1-wnht2.s3.eu-west-1.amazonaws.com"
			}
		}
		resources: {
			"bucket-001": resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: {
					annotations: {
						"crossplane.io/composition-resource-name": "bucket-001"
						"crossplane.io/external-create-pending":   "2023-10-19T02:13:17Z"
						"crossplane.io/external-create-succeeded": "2023-10-19T02:13:17Z"
						"crossplane.io/external-name":             "bucket1-wnht2-001"
						"upjet.crossplane.io/provider-meta":       "{\"e2bfb730-ecaa-11e6-8f88-34363bc7c4c0\":{\"create\":1200000000000,\"delete\":3600000000000,\"read\":1200000000000,\"update\":1200000000000}}"
					}
					finalizers: [
						"finalizer.managedresource.crossplane.io",
					]
					generateName: "bucket1-wnht2-"
					labels: {
						"crossplane.io/claim-name":      "bucket1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "bucket1-wnht2"
					}
					name: "bucket1-wnht2-001"
					ownerReferences: [
						{
							apiVersion:         "simple.cuefn.example.com/v1alpha1"
							blockOwnerDeletion: true
							controller:         true
							kind:               "XS3Bucket"
							name:               "bucket1-wnht2"
							uid:                "9263eb6b-bb52-4311-8e71-80b0abecd26a"
						},
					]
				}
				spec: {
					deletionPolicy: "Delete"
					forProvider: {
						forceDestroy: true
						region:       "eu-west-1"
						tags: {
							"bucket.owner":              "me"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-wnht2-001"
							"crossplane-providerconfig": "default"
						}
					}
					initProvider: {}
					managementPolicies: [
						"*",
					]
					providerConfigRef: name: "default"
				}
				status: {
					atProvider: {
						accelerationStatus:       ""
						arn:                      "arn:aws:s3:::bucket1-wnht2-001"
						bucketDomainName:         "bucket1-wnht2-001.s3.amazonaws.com"
						bucketRegionalDomainName: "bucket1-wnht2-001.s3.eu-west-1.amazonaws.com"
						forceDestroy:             true
						grant: [
							{
								id: "ab1df3362e37784fd3e84db15a3a1c5fdd3e9bc9160a33f350eb9eaf48bdc289"
								permissions: [
									"FULL_CONTROL",
								]
								type: "CanonicalUser"
								uri:  ""
							},
						]
						hostedZoneId:      "Z1BKCTXD74EZPE"
						id:                "bucket1-wnht2-001"
						objectLockEnabled: false
						policy:            ""
						requestPayer:      "BucketOwner"
						serverSideEncryptionConfiguration: [
							{
								rule: [
									{
										applyServerSideEncryptionByDefault: [
											{
												kmsMasterKeyId: ""
												sseAlgorithm:   "AES256"
											},
										]
										bucketKeyEnabled: false
									},
								]
							},
						]
						tags: {
							"bucket.owner":              "me"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-wnht2-001"
							"crossplane-providerconfig": "default"
						}
						tagsAll: {
							"bucket.owner":              "me"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-wnht2-001"
							"crossplane-providerconfig": "default"
						}
						versioning: [
							{
								enabled:   false
								mfaDelete: false
							},
						]
					}
					conditions: [
						{
							lastTransitionTime: "2023-10-19T02:13:38Z"
							reason:             "Available"
							status:             "True"
							type:               "Ready"
						},
						{
							lastTransitionTime: "2023-10-21T19:14:45Z"
							reason:             "ReconcileSuccess"
							status:             "True"
							type:               "Synced"
						},
						{
							lastTransitionTime: "2023-10-19T02:13:25Z"
							reason:             "Success"
							status:             "True"
							type:               "LastAsyncOperation"
						},
						{
							lastTransitionTime: "2023-10-19T02:13:25Z"
							reason:             "Finished"
							status:             "True"
							type:               "AsyncOperation"
						},
					]
				}
			}
			"bucket-002": resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: {
					annotations: {
						"crossplane.io/composition-resource-name": "bucket-002"
						"crossplane.io/external-create-pending":   "2023-10-19T02:13:17Z"
						"crossplane.io/external-create-succeeded": "2023-10-19T02:13:17Z"
						"crossplane.io/external-name":             "bucket1-wnht2-002"
						"upjet.crossplane.io/provider-meta":       "{\"e2bfb730-ecaa-11e6-8f88-34363bc7c4c0\":{\"create\":1200000000000,\"delete\":3600000000000,\"read\":1200000000000,\"update\":1200000000000}}"
					}
					finalizers: [
						"finalizer.managedresource.crossplane.io",
					]
					generateName: "bucket1-wnht2-"
					labels: {
						"crossplane.io/claim-name":      "bucket1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "bucket1-wnht2"
					}
					name: "bucket1-wnht2-002"
					ownerReferences: [
						{
							apiVersion:         "simple.cuefn.example.com/v1alpha1"
							blockOwnerDeletion: true
							controller:         true
							kind:               "XS3Bucket"
							name:               "bucket1-wnht2"
							uid:                "9263eb6b-bb52-4311-8e71-80b0abecd26a"
						},
					]
				}
				spec: {
					deletionPolicy: "Delete"
					forProvider: {
						forceDestroy: true
						region:       "eu-west-1"
						tags: {
							"bucket.owner":              "me"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-wnht2-002"
							"crossplane-providerconfig": "default"
						}
					}
					initProvider: {}
					managementPolicies: [
						"*",
					]
					providerConfigRef: name: "default"
				}
				status: {
					atProvider: {
						accelerationStatus:       ""
						arn:                      "arn:aws:s3:::bucket1-wnht2-002"
						bucketDomainName:         "bucket1-wnht2-002.s3.amazonaws.com"
						bucketRegionalDomainName: "bucket1-wnht2-002.s3.eu-west-1.amazonaws.com"
						forceDestroy:             true
						grant: [
							{
								id: "ab1df3362e37784fd3e84db15a3a1c5fdd3e9bc9160a33f350eb9eaf48bdc289"
								permissions: [
									"FULL_CONTROL",
								]
								type: "CanonicalUser"
								uri:  ""
							},
						]
						hostedZoneId:      "Z1BKCTXD74EZPE"
						id:                "bucket1-wnht2-002"
						objectLockEnabled: false
						policy:            ""
						requestPayer:      "BucketOwner"
						serverSideEncryptionConfiguration: [
							{
								rule: [
									{
										applyServerSideEncryptionByDefault: [
											{
												kmsMasterKeyId: ""
												sseAlgorithm:   "AES256"
											},
										]
										bucketKeyEnabled: false
									},
								]
							},
						]
						tags: {
							"bucket.owner":              "me"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-wnht2-002"
							"crossplane-providerconfig": "default"
						}
						tagsAll: {
							"bucket.owner":              "me"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-wnht2-002"
							"crossplane-providerconfig": "default"
						}
						versioning: [
							{
								enabled:   false
								mfaDelete: false
							},
						]
					}
					conditions: [
						{
							lastTransitionTime: "2023-10-19T02:13:41Z"
							reason:             "Available"
							status:             "True"
							type:               "Ready"
						},
						{
							lastTransitionTime: "2023-10-21T19:14:42Z"
							reason:             "ReconcileSuccess"
							status:             "True"
							type:               "Synced"
						},
						{
							lastTransitionTime: "2023-10-19T02:13:24Z"
							reason:             "Success"
							status:             "True"
							type:               "LastAsyncOperation"
						},
						{
							lastTransitionTime: "2023-10-19T02:13:24Z"
							reason:             "Finished"
							status:             "True"
							type:               "AsyncOperation"
						},
					]
				}
			}
			main: resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: {
					annotations: {
						"crossplane.io/composition-resource-name": "main"
						"crossplane.io/external-create-pending":   "2023-10-19T02:13:17Z"
						"crossplane.io/external-create-succeeded": "2023-10-19T02:13:17Z"
						"crossplane.io/external-name":             "bucket1-wnht2"
						"upjet.crossplane.io/provider-meta":       "{\"e2bfb730-ecaa-11e6-8f88-34363bc7c4c0\":{\"create\":1200000000000,\"delete\":3600000000000,\"read\":1200000000000,\"update\":1200000000000}}"
					}
					finalizers: [
						"finalizer.managedresource.crossplane.io",
					]
					generateName: "bucket1-wnht2-"
					labels: {
						"crossplane.io/claim-name":      "bucket1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "bucket1-wnht2"
					}
					name: "bucket1-wnht2"
					ownerReferences: [
						{
							apiVersion:         "simple.cuefn.example.com/v1alpha1"
							blockOwnerDeletion: true
							controller:         true
							kind:               "XS3Bucket"
							name:               "bucket1-wnht2"
							uid:                "9263eb6b-bb52-4311-8e71-80b0abecd26a"
						},
					]
				}
				spec: {
					deletionPolicy: "Delete"
					forProvider: {
						forceDestroy: true
						region:       "eu-west-1"
						tags: {
							"bucket.owner":              "me"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-wnht2"
							"crossplane-providerconfig": "default"
						}
					}
					initProvider: {}
					managementPolicies: [
						"*",
					]
					providerConfigRef: name: "default"
				}
				status: {
					atProvider: {
						accelerationStatus:       ""
						arn:                      "arn:aws:s3:::bucket1-wnht2"
						bucketDomainName:         "bucket1-wnht2.s3.amazonaws.com"
						bucketRegionalDomainName: "bucket1-wnht2.s3.eu-west-1.amazonaws.com"
						forceDestroy:             true
						grant: [
							{
								id: "ab1df3362e37784fd3e84db15a3a1c5fdd3e9bc9160a33f350eb9eaf48bdc289"
								permissions: [
									"FULL_CONTROL",
								]
								type: "CanonicalUser"
								uri:  ""
							},
						]
						hostedZoneId:      "Z1BKCTXD74EZPE"
						id:                "bucket1-wnht2"
						objectLockEnabled: false
						policy:            ""
						requestPayer:      "BucketOwner"
						serverSideEncryptionConfiguration: [
							{
								rule: [
									{
										applyServerSideEncryptionByDefault: [
											{
												kmsMasterKeyId: ""
												sseAlgorithm:   "AES256"
											},
										]
										bucketKeyEnabled: false
									},
								]
							},
						]
						tags: {
							"bucket.owner":              "me"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-wnht2"
							"crossplane-providerconfig": "default"
						}
						tagsAll: {
							"bucket.owner":              "me"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-wnht2"
							"crossplane-providerconfig": "default"
						}
						versioning: [
							{
								enabled:   false
								mfaDelete: false
							},
						]
					}
					conditions: [
						{
							lastTransitionTime: "2023-10-19T02:13:36Z"
							reason:             "Available"
							status:             "True"
							type:               "Ready"
						},
						{
							lastTransitionTime: "2023-10-21T19:14:53Z"
							reason:             "ReconcileSuccess"
							status:             "True"
							type:               "Synced"
						},
						{
							lastTransitionTime: "2023-10-19T02:13:24Z"
							reason:             "Success"
							status:             "True"
							type:               "LastAsyncOperation"
						},
						{
							lastTransitionTime: "2023-10-19T02:13:24Z"
							reason:             "Finished"
							status:             "True"
							type:               "AsyncOperation"
						},
					]
				}
			}
		}
	}
}

// expected output
response: desired: composite: resource: status: {
	additionalEndpoints: [
		"bucket1-wnht2-001.s3.eu-west-1.amazonaws.com",
		"bucket1-wnht2-002.s3.eu-west-1.amazonaws.com",
	]
	primaryEndpoint: "bucket1-wnht2.s3.eu-west-1.amazonaws.com"
}

response: desired: resources: {
	"bucket-001": {
		resource: {
			apiVersion: "s3.aws.upbound.io/v1beta1"
			kind:       "Bucket"
			metadata: name: "bucket1-wnht2-001"
			spec: forProvider: {
				forceDestroy: true
				region:       "eu-west-1"
				tags: "bucket.owner": "me"
			}
		}
	}
	"bucket-002": {
		resource: {
			apiVersion: "s3.aws.upbound.io/v1beta1"
			kind:       "Bucket"
			metadata: name: "bucket1-wnht2-002"
			spec: forProvider: {
				forceDestroy: true
				region:       "eu-west-1"
				tags: "bucket.owner": "me"
			}
		}
	}
	main: {
		resource: {
			apiVersion: "s3.aws.upbound.io/v1beta1"
			kind:       "Bucket"
			metadata: name: "bucket1-wnht2"
			spec: forProvider: {
				forceDestroy: true
				region:       "eu-west-1"
				tags: "bucket.owner": "me"
			}
		}
	}

	iam_policy: resource: {
		apiVersion: "iam.aws.upbound.io/v1beta1"
		kind:       "Policy"
		metadata: name: "bucket1-wnht2-access-policy"
		spec: forProvider: {
			path: "/"
			policy: json.Marshal({
				Version: "2012-10-17"
				Statement: [
					{
						Sid: "S3BucketAccess"
						Action: [
							"s3:GetObject",
							"s3:PutObject",
						]
						Effect: "Allow"
						Resource: [
							"arn:aws:s3:::bucket1-wnht2",
							"arn:aws:s3:::bucket1-wnht2/*",
							"arn:aws:s3:::bucket1-wnht2-001",
							"arn:aws:s3:::bucket1-wnht2-001/*",
							"arn:aws:s3:::bucket1-wnht2-002",
							"arn:aws:s3:::bucket1-wnht2-002/*",
						]
					},
				]
			})
		}
	}
}
