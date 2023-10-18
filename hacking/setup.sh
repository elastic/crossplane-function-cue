#!/bin/bash

set -euo pipefail

helm repo add crossplane-master https://charts.crossplane.io/master/
helm repo update

set +e # since second time install will fail
helm install crossplane --namespace crossplane-system --create-namespace crossplane-master/crossplane --devel
set -e

helm upgrade crossplane --namespace crossplane-system --create-namespace crossplane-master/crossplane --devel
