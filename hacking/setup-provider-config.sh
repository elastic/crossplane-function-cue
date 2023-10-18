set -euo pipefail

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
      namespace: crossplane-system
    source: Secret
EOF
