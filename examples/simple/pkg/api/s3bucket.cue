package api

import (
	"strings"
)

// this file specifies the types for the S3 bucket user claim

#Suffix: string
#Suffix: strings.MaxRunes(4)
#Suffix: strings.MinRunes(1)

#Tags: [string]: string

// allow creation of one of more S3 buckets
#S3BucketV1alpha1: {
	// desired state
	spec: {
		// bucket creation parameters
		parameters: {
			// bucket region
			region: string
			// additional buckets to create with the suffixes provided
			additionalSuffixes?: [... #Suffix]
			// tags to associate with all buckets
			tags?: #Tags
		}
	}
	// observed status
	status?: {
		// the URL of the bucket endpoint
		primaryEndpoint?: string
		// additional endpoints in the same order as additional suffixes
		additionalEndpoints?: [... string]
		// the ARN of the IAM policy created for accessing the buckets
		iamPolicyARN?: string
	}
}
