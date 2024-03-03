#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/.env"

if [[ "${XP_PROVIDER_AWS_CONFIGURE}" != "true" ]]
then
  echo "AWS providers will not be set up since you have opted out"
  exit 0
fi

XP_PROVIDER_AWS_VERSION=${XP_PROVIDER_AWS_VERSION:-v0.46.0}

echo "Applying AWS providers"
${RUN_KUBECTL} apply -f - <<EOF
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-s3
  labels:
    app.kubernetes.io/component: crossplane-aws-provider
spec:
  package: xpkg.upbound.io/upbound/provider-aws-s3:${XP_PROVIDER_AWS_VERSION}
EOF

${RUN_KUBECTL} apply -f - <<EOF
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-iam
  labels:
    app.kubernetes.io/component: crossplane-aws-provider
spec:
  package: xpkg.upbound.io/upbound/provider-aws-iam:${XP_PROVIDER_AWS_VERSION}
EOF

echo "Waiting for the crossplane AWS providers to be ready. This could take some minutes..."
${RUN_KUBECTL} wait --timeout=600s --for=condition=Healthy providers.pkg.crossplane.io -l app.kubernetes.io/component=crossplane-aws-provider

echo apply aws provider config
kubectl apply -f - <<EOF
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    secretRef:
      key: creds
      name: aws-default
      namespace: ${XP_CROSSPLANE_NS}
    source: Secret
EOF

