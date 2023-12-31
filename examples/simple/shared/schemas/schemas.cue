package schemas

{
	openapi: "3.0.0"
	info: {
		description: "Generated by xp-function-cue, DO NOT EDIT"
		title:       "XRD schemas"
		version:     "0.1.0"
	}
	paths: {}
	components: schemas: {
		S3BucketV1alpha1: {
			description: "allow creation of one of more S3 buckets"
			type:        "object"
			required: [
				"spec",
			]
			properties: {
				spec: {
					description: "desired state"
					type:        "object"
					required: [
						"parameters",
					]
					properties: parameters: {
						description: "bucket creation parameters"
						type:        "object"
						required: [
							"region",
						]
						properties: {
							region: {
								description: "bucket region"
								type:        "string"
							}
							additionalSuffixes: {
								description: "additional buckets to create with the suffixes provided"
								type:        "array"
								items: {
									type:      "string"
									minLength: 1
									maxLength: 4
								}
							}
							tags: {
								description: "tags to associate with all buckets"
								type:        "object"
								additionalProperties: type: "string"
							}
						}
					}
				}
				status: {
					description: "observed status"
					type:        "object"
					properties: {
						primaryEndpoint: {
							description: "the URL of the bucket endpoint"
							type:        "string"
						}
						additionalEndpoints: {
							description: "additional endpoints in the same order as additional suffixes"
							type:        "array"
							items: type: "string"
						}
						iamPolicyARN: {
							description: "the ARN of the IAM policy created for accessing the buckets"
							type:        "string"
						}
					}
				}
			}
		}
		Suffix: {
			type:      "string"
			minLength: 1
			maxLength: 4
		}
		Tags: {
			type: "object"
			additionalProperties: type: "string"
		}
	}
}
