setting up
---

* Start with an empty cluster (e.g. docker-desktop)
* Run `setup.sh` which installs bleeding edge crossplane
* Wait for a while until crossplane installs CRDs
* Run `setup-providers.sh` to install providers
* Wait for a while until the provider pods come up
* Run `setup-provider-config.sh` to set up a default AWS provider

