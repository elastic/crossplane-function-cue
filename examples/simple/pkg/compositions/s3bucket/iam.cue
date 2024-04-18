package s3bucket

import (
	"encoding/json"
	"list"
)

let mainARN = #request.observed.resources.main.resource.status.atProvider.arn
let baseARN = [
	if mainARN != _|_ {mainARN},
	{"unknown"},
][0]

let arns = [
	for s in suffixes {
		let bucketName = "bucket\(s)"
		let arn = #request.observed.resources[bucketName].resource.status.atProvider.arn
		[
			if arn != _|_ {arn},
			"unknown",
		][0]
	},
]

// additionalARNs is the list of known additional bucket ARNs
let additionalARNs = [for e in arns if e != "unknown" {e}]

// if we have a base ARN, render a policy with that and any additional ARNs available.
if baseARN != "unknown" {
	let allTuples = list.Concat([
		[baseARN, baseARN + "/*"],
		[
			for a in additionalARNs {[a, a + "/*"]},
		],
	])
	let allResources = list.FlattenN( allTuples, 1)
	response: desired: resources: iam_policy: resource: {
		apiVersion: "iam.aws.upbound.io/v1beta1"
		kind:       "Policy"
		metadata: {
			name: "\(compName)-access-policy"
		}
		spec: {
			forProvider: {
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
							Effect:   "Allow"
							Resource: allResources
						},
					]
				})
			}
		}
	}
}

// set the policy ARN on the status if found
{
	let policyARN = #request.observed.resources.iam_policy.resource.status.atProvider.arn
	if policyARN != _|_ {
		response: desired: composite: resource: status: iamPolicyARN: policyARN
	}
}
