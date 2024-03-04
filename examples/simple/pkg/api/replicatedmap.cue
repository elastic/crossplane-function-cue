package api

// A config map that is replicated to multiple namespaces
#ReplicatedMapV1alpha1: {
	// desired state of the replicated config map
	spec: {
		// input parameters
		parameters: {
			// data for the config map that will be created
			data: [string]: string
			// the namespaces to replicate the config map
			namespaces: [...string]
			// optional name for the config map. Default is the claim name
			name?: string
		}
	}
}
