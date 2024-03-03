#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/.env"

XP_CROSSPLANE_VERSION="${XP_CROSSPLANE_VERSION:-1.14.3}"

$RUN_KUBECTL apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${XP_CROSSPLANE_NS}
EOF

${RUN_HELM} repo add --force-update crossplane-stable https://charts.crossplane.io/stable/
${RUN_HELM} repo update > /dev/null

# shellcheck disable=SC2089
OPTS="crossplane --set args={\"--enable-environment-configs\"} --namespace ${XP_CROSSPLANE_NS} --create-namespace crossplane-stable/crossplane --version $XP_CROSSPLANE_VERSION"

# shellcheck disable=SC2090
${RUN_HELM} template --include-crds ${OPTS} | ${RUN_KUBECTL} apply -f -

echo "Waiting for Crossplane to be ready..."
${RUN_KUBECTL} wait --timeout=180s --for=condition=Available -n ${XP_CROSSPLANE_NS} deployments crossplane
${RUN_KUBECTL} wait --timeout=180s --for=condition=Established customresourcedefinition.apiextensions.k8s.io providers.pkg.crossplane.io
