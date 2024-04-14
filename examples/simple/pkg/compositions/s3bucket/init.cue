package s3bucket

// implementation note: all internal top-level variables should be defined in this file because of
// https://github.com/cue-lang/cue/issues/2648

// responses should be generated based on the request object. The variable below declares it as an open struct
// so that it can be referenced in expressions.
request: {...}

// create some fields for easy access to nested JSON paths and provide defaults
composite: request.observed.composite.resource
compName:  composite.metadata.name

spec:      composite.spec
tagValues: [
		if composite.spec.parameters.tags != _|_ {composite.spec.parameters.tags},
		{},
][0]
suffixes: [
		if spec.parameters.additionalSuffixes != _|_ {spec.parameters.additionalSuffixes},
		[],
][0]
