package runtime

import (
	"encoding/json"
	"list"
)

let resource0 = [
	if _request.observed.resources.main.resource.status.atProvider.arn != _|_ {
		r: _request.observed.resources.main.resource.status.atProvider.arn
	},
	{r: "unknown"},
][0].r

let arns0 = [
	for s in _suffixes {
		let bucketName = "bucket\(s)"
		[
			if _request.observed.resources[bucketName].resource.status.atProvider.arn != _|_ {
				_request.observed.resources[bucketName].resource.status.atProvider.arn
			},
			"unknown",
		][0]
	},
]
let arns1 = [ for e in arns0 if e != "unknown" {e}]

// if we have all the ARNs, why not create a policy?
if len(arns1) == len(_suffixes) && resource0 != "unknown" {
	let resources0 = list.FlattenN(
	list.Concat([
		[
			"\(resource0)",
			"\(resource0)/*",
		],
		[
			for a in arns1 {
				[
					"\(a)",
					"\(a)/*",
				]
			},
		],
	]), 1,
	)
	resources: iam_policy: {
		resource: {
			apiVersion: "iam.aws.upbound.io/v1beta1"
			kind:       "Policy"
			metadata: {
				name: "\(_composite.metadata.name)-access-policy"
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
								Resource: resources0
							},
						]
					})
				}
			}
		}
		ready: (#readyValue & {in: _request.observed.resources.iam_policy.resource.status.conditions}).out
	}
}

// set the policy ARN on the status if found
if _request.observed.resources.iam_policy.resource.status.atProvider.arn != _|_ {
	composite: resource: {
		status: {
			iamPolicyARN: _request.observed.resources.iam_policy.resource.status.atProvider.arn
		}
	}
}
