@if(final)
package tests

_request: {
	context: {}
	desired: {}
	observed: {
		composite: resource: {
			apiVersion: "simple.cuefn.example.com/v1alpha1"
			kind:       "XS3Bucket"
			metadata: {
				finalizers: [
					"composite.apiextensions.crossplane.io",
				]
				generateName: "bucket1-"
				labels: {
					"crossplane.io/claim-name":      "bucket1"
					"crossplane.io/claim-namespace": "claims"
					"crossplane.io/composite":       "bucket1-k4fvm"
				}
				name: "bucket1-k4fvm"
			}
			spec: {
				claimRef: {
					apiVersion: "simple.cuefn.example.com/v1alpha1"
					kind:       "S3Bucket"
					name:       "bucket1"
					namespace:  "claims"
				}
				compositionRef: name:         "xs3buckets.simple.cuefn.example.com"
				compositionRevisionRef: name: "xs3buckets.simple.cuefn.example.com-c23f3ab"
				compositionUpdatePolicy: "Automatic"
				parameters: {
					additionalSuffixes: [
						"-001",
						"-002",
					]
					region: "eu-west-1"
					tags: "bucket.purpose": "test-crossplane-cue-functions"
				}
				resourceRefs: [
					{
						apiVersion: "iam.aws.upbound.io/v1beta1"
						kind:       "Policy"
						name:       "bucket1-k4fvm-access-policy"
					},
					{
						apiVersion: "s3.aws.upbound.io/v1beta1"
						kind:       "Bucket"
						name:       "bucket1-k4fvm"
					},
					{
						apiVersion: "s3.aws.upbound.io/v1beta1"
						kind:       "Bucket"
						name:       "bucket1-k4fvm-001"
					},
					{
						apiVersion: "s3.aws.upbound.io/v1beta1"
						kind:       "Bucket"
						name:       "bucket1-k4fvm-002"
					},
				]
			}
			status: {
				additionalEndpoints: [
					"bucket1-k4fvm-001.s3.eu-west-1.amazonaws.com",
					"bucket1-k4fvm-002.s3.eu-west-1.amazonaws.com",
				]
				conditions: [
					{
						lastTransitionTime: "2023-10-28T21:01:05Z"
						reason:             "ReconcileSuccess"
						status:             "True"
						type:               "Synced"
					},
					{
						lastTransitionTime: "2023-10-28T21:41:17Z"
						reason:             "Available"
						status:             "True"
						type:               "Ready"
					},
				]
				iamPolicyARN:    "arn:aws:iam::816427873776:policy/bucket1-k4fvm-access-policy"
				primaryEndpoint: "bucket1-k4fvm.s3.eu-west-1.amazonaws.com"
			}
		}
		resources: {
			"bucket-001": resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: {
					annotations: {
						"crossplane.io/composition-resource-name": "bucket-001"
						"crossplane.io/external-create-pending":   "2023-10-28T20:29:09Z"
						"crossplane.io/external-create-succeeded": "2023-10-28T20:29:09Z"
						"crossplane.io/external-name":             "bucket1-k4fvm-001"
						"upjet.crossplane.io/provider-meta":       "{\"e2bfb730-ecaa-11e6-8f88-34363bc7c4c0\":{\"create\":1200000000000,\"delete\":3600000000000,\"read\":1200000000000,\"update\":1200000000000}}"
					}
					finalizers: [
						"finalizer.managedresource.crossplane.io",
					]
					generateName: "bucket1-k4fvm-"
					labels: {
						"crossplane.io/claim-name":      "bucket1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "bucket1-k4fvm"
					}
					name: "bucket1-k4fvm-001"
					ownerReferences: [
						{
							apiVersion:         "simple.cuefn.example.com/v1alpha1"
							blockOwnerDeletion: true
							controller:         true
							kind:               "XS3Bucket"
							name:               "bucket1-k4fvm"
							uid:                "86cc2c8e-710d-46f9-ac96-94a29a798c08"
						},
					]
				}
				spec: {
					deletionPolicy: "Delete"
					forProvider: {
						forceDestroy: true
						region:       "eu-west-1"
						tags: {
							"bucket.purpose":            "test-crossplane-cue-functions"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm-001"
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
						arn:                      "arn:aws:s3:::bucket1-k4fvm-001"
						bucketDomainName:         "bucket1-k4fvm-001.s3.amazonaws.com"
						bucketRegionalDomainName: "bucket1-k4fvm-001.s3.eu-west-1.amazonaws.com"
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
						id:                "bucket1-k4fvm-001"
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
							"bucket.purpose":            "test-crossplane-cue-functions"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm-001"
							"crossplane-providerconfig": "default"
						}
						tagsAll: {
							"bucket.purpose":            "test-crossplane-cue-functions"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm-001"
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
							lastTransitionTime: "2023-10-28T20:29:30Z"
							reason:             "Available"
							status:             "True"
							type:               "Ready"
						},
						{
							lastTransitionTime: "2023-10-28T21:02:48Z"
							reason:             "ReconcileSuccess"
							status:             "True"
							type:               "Synced"
						},
						{
							lastTransitionTime: "2023-10-28T20:29:15Z"
							reason:             "Success"
							status:             "True"
							type:               "LastAsyncOperation"
						},
						{
							lastTransitionTime: "2023-10-28T20:29:15Z"
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
						"crossplane.io/external-create-pending":   "2023-10-28T20:29:09Z"
						"crossplane.io/external-create-succeeded": "2023-10-28T20:29:09Z"
						"crossplane.io/external-name":             "bucket1-k4fvm-002"
						"upjet.crossplane.io/provider-meta":       "{\"e2bfb730-ecaa-11e6-8f88-34363bc7c4c0\":{\"create\":1200000000000,\"delete\":3600000000000,\"read\":1200000000000,\"update\":1200000000000}}"
					}
					finalizers: [
						"finalizer.managedresource.crossplane.io",
					]
					generateName: "bucket1-k4fvm-"
					labels: {
						"crossplane.io/claim-name":      "bucket1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "bucket1-k4fvm"
					}
					name: "bucket1-k4fvm-002"
					ownerReferences: [
						{
							apiVersion:         "simple.cuefn.example.com/v1alpha1"
							blockOwnerDeletion: true
							controller:         true
							kind:               "XS3Bucket"
							name:               "bucket1-k4fvm"
							uid:                "86cc2c8e-710d-46f9-ac96-94a29a798c08"
						},
					]
				}
				spec: {
					deletionPolicy: "Delete"
					forProvider: {
						forceDestroy: true
						region:       "eu-west-1"
						tags: {
							"bucket.purpose":            "test-crossplane-cue-functions"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm-002"
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
						arn:                      "arn:aws:s3:::bucket1-k4fvm-002"
						bucketDomainName:         "bucket1-k4fvm-002.s3.amazonaws.com"
						bucketRegionalDomainName: "bucket1-k4fvm-002.s3.eu-west-1.amazonaws.com"
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
						id:                "bucket1-k4fvm-002"
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
							"bucket.purpose":            "test-crossplane-cue-functions"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm-002"
							"crossplane-providerconfig": "default"
						}
						tagsAll: {
							"bucket.purpose":            "test-crossplane-cue-functions"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm-002"
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
							lastTransitionTime: "2023-10-28T20:29:30Z"
							reason:             "Available"
							status:             "True"
							type:               "Ready"
						},
						{
							lastTransitionTime: "2023-10-28T21:03:00Z"
							reason:             "ReconcileSuccess"
							status:             "True"
							type:               "Synced"
						},
						{
							lastTransitionTime: "2023-10-28T20:29:15Z"
							reason:             "Success"
							status:             "True"
							type:               "LastAsyncOperation"
						},
						{
							lastTransitionTime: "2023-10-28T20:29:15Z"
							reason:             "Finished"
							status:             "True"
							type:               "AsyncOperation"
						},
					]
				}
			}
			iam_policy: resource: {
				apiVersion: "iam.aws.upbound.io/v1beta1"
				kind:       "Policy"
				metadata: {
					annotations: {
						"crossplane.io/composition-resource-name": "iam_policy"
						"crossplane.io/external-create-pending":   "2023-10-28T21:20:38Z"
						"crossplane.io/external-create-succeeded": "2023-10-28T21:20:38Z"
						"crossplane.io/external-name":             "bucket1-k4fvm-access-policy"
						"upjet.crossplane.io/provider-meta":       "null"
					}
					finalizers: [
						"finalizer.managedresource.crossplane.io",
					]
					generateName: "bucket1-k4fvm-"
					labels: {
						"crossplane.io/claim-name":      "bucket1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "bucket1-k4fvm"
					}
					name: "bucket1-k4fvm-access-policy"
					ownerReferences: [
						{
							apiVersion:         "simple.cuefn.example.com/v1alpha1"
							blockOwnerDeletion: true
							controller:         true
							kind:               "XS3Bucket"
							name:               "bucket1-k4fvm"
							uid:                "86cc2c8e-710d-46f9-ac96-94a29a798c08"
						},
					]
				}
				spec: {
					deletionPolicy: "Delete"
					forProvider: {
						path:   "/"
						policy: "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"S3BucketAccess\",\"Action\":[\"s3:GetObject\",\"s3:PutObject\"],\"Effect\":\"Allow\",\"Resource\":[\"arn:aws:s3:::bucket1-k4fvm\",\"arn:aws:s3:::bucket1-k4fvm/*\",\"arn:aws:s3:::bucket1-k4fvm-001\",\"arn:aws:s3:::bucket1-k4fvm-001/*\",\"arn:aws:s3:::bucket1-k4fvm-002\",\"arn:aws:s3:::bucket1-k4fvm-002/*\"]}]}"
						tags: {
							"crossplane-kind":           "policy.iam.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm-access-policy"
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
						arn:         "arn:aws:iam::816427873776:policy/bucket1-k4fvm-access-policy"
						description: ""
						id:          "arn:aws:iam::816427873776:policy/bucket1-k4fvm-access-policy"
						path:        "/"
						policy:      "{\"Statement\":[{\"Action\":[\"s3:GetObject\",\"s3:PutObject\"],\"Effect\":\"Allow\",\"Resource\":[\"arn:aws:s3:::bucket1-k4fvm\",\"arn:aws:s3:::bucket1-k4fvm/*\",\"arn:aws:s3:::bucket1-k4fvm-001\",\"arn:aws:s3:::bucket1-k4fvm-001/*\",\"arn:aws:s3:::bucket1-k4fvm-002\",\"arn:aws:s3:::bucket1-k4fvm-002/*\"],\"Sid\":\"S3BucketAccess\"}],\"Version\":\"2012-10-17\"}"
						policyId:    "ANPA34FXEWXYAXI6KVF6L"
						tags: {
							"crossplane-kind":           "policy.iam.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm-access-policy"
							"crossplane-providerconfig": "default"
						}
						tagsAll: {
							"crossplane-kind":           "policy.iam.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm-access-policy"
							"crossplane-providerconfig": "default"
						}
					}
					conditions: [
						{
							lastTransitionTime: "2023-10-28T21:20:56Z"
							reason:             "Available"
							status:             "True"
							type:               "Ready"
						},
						{
							lastTransitionTime: "2023-10-28T21:19:21Z"
							reason:             "ReconcileSuccess"
							status:             "True"
							type:               "Synced"
						},
						{
							lastTransitionTime: "2023-10-28T21:20:40Z"
							reason:             "Success"
							status:             "True"
							type:               "LastAsyncOperation"
						},
						{
							lastTransitionTime: "2023-10-28T21:19:22Z"
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
						"crossplane.io/external-create-pending":   "2023-10-28T20:29:09Z"
						"crossplane.io/external-create-succeeded": "2023-10-28T20:29:09Z"
						"crossplane.io/external-name":             "bucket1-k4fvm"
						"upjet.crossplane.io/provider-meta":       "{\"e2bfb730-ecaa-11e6-8f88-34363bc7c4c0\":{\"create\":1200000000000,\"delete\":3600000000000,\"read\":1200000000000,\"update\":1200000000000}}"
					}
					finalizers: [
						"finalizer.managedresource.crossplane.io",
					]
					generateName: "bucket1-k4fvm-"
					labels: {
						"crossplane.io/claim-name":      "bucket1"
						"crossplane.io/claim-namespace": "claims"
						"crossplane.io/composite":       "bucket1-k4fvm"
					}
					name: "bucket1-k4fvm"
					ownerReferences: [
						{
							apiVersion:         "simple.cuefn.example.com/v1alpha1"
							blockOwnerDeletion: true
							controller:         true
							kind:               "XS3Bucket"
							name:               "bucket1-k4fvm"
							uid:                "86cc2c8e-710d-46f9-ac96-94a29a798c08"
						},
					]
				}
				spec: {
					deletionPolicy: "Delete"
					forProvider: {
						forceDestroy: true
						region:       "eu-west-1"
						tags: {
							"bucket.purpose":            "test-crossplane-cue-functions"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm"
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
						arn:                      "arn:aws:s3:::bucket1-k4fvm"
						bucketDomainName:         "bucket1-k4fvm.s3.amazonaws.com"
						bucketRegionalDomainName: "bucket1-k4fvm.s3.eu-west-1.amazonaws.com"
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
						id:                "bucket1-k4fvm"
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
							"bucket.purpose":            "test-crossplane-cue-functions"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm"
							"crossplane-providerconfig": "default"
						}
						tagsAll: {
							"bucket.purpose":            "test-crossplane-cue-functions"
							"crossplane-kind":           "bucket.s3.aws.upbound.io"
							"crossplane-name":           "bucket1-k4fvm"
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
							lastTransitionTime: "2023-10-28T20:29:27Z"
							reason:             "Available"
							status:             "True"
							type:               "Ready"
						},
						{
							lastTransitionTime: "2023-10-28T21:03:01Z"
							reason:             "ReconcileSuccess"
							status:             "True"
							type:               "Synced"
						},
						{
							lastTransitionTime: "2023-10-28T20:29:16Z"
							reason:             "Success"
							status:             "True"
							type:               "LastAsyncOperation"
						},
						{
							lastTransitionTime: "2023-10-28T20:29:16Z"
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

{
	composite: resource: status: {
		additionalEndpoints: [
			"bucket1-k4fvm-001.s3.eu-west-1.amazonaws.com",
			"bucket1-k4fvm-002.s3.eu-west-1.amazonaws.com",
		]
		iamPolicyARN:    "arn:aws:iam::816427873776:policy/bucket1-k4fvm-access-policy"
		primaryEndpoint: "bucket1-k4fvm.s3.eu-west-1.amazonaws.com"
	}
	resources: {
		"bucket-001": {
			ready: "READY_TRUE"
			resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: name: "bucket1-k4fvm-001"
				spec: forProvider: {
					forceDestroy: true
					region:       "eu-west-1"
					tags: "bucket.purpose": "test-crossplane-cue-functions"
				}
			}
		}
		"bucket-002": {
			ready: "READY_TRUE"
			resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: name: "bucket1-k4fvm-002"
				spec: forProvider: {
					forceDestroy: true
					region:       "eu-west-1"
					tags: "bucket.purpose": "test-crossplane-cue-functions"
				}
			}
		}
		iam_policy: {
			ready: "READY_TRUE"
			resource: {
				apiVersion: "iam.aws.upbound.io/v1beta1"
				kind:       "Policy"
				metadata: name: "bucket1-k4fvm-access-policy"
				spec: forProvider: {
					path:   "/"
					policy: "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"S3BucketAccess\",\"Action\":[\"s3:GetObject\",\"s3:PutObject\"],\"Effect\":\"Allow\",\"Resource\":[\"arn:aws:s3:::bucket1-k4fvm\",\"arn:aws:s3:::bucket1-k4fvm/*\",\"arn:aws:s3:::bucket1-k4fvm-001\",\"arn:aws:s3:::bucket1-k4fvm-001/*\",\"arn:aws:s3:::bucket1-k4fvm-002\",\"arn:aws:s3:::bucket1-k4fvm-002/*\"]}]}"
				}
			}
		}
		main: {
			ready: "READY_TRUE"
			resource: {
				apiVersion: "s3.aws.upbound.io/v1beta1"
				kind:       "Bucket"
				metadata: name: "bucket1-k4fvm"
				spec: forProvider: {
					forceDestroy: true
					region:       "eu-west-1"
					tags: "bucket.purpose": "test-crossplane-cue-functions"
				}
			}
		}
	}
}
