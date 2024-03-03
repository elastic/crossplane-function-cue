package s3bucket

// implementation note: all internal top-level variables should be defined in this file because of
// https://github.com/cue-lang/cue/issues/2648

// responses should be generated based on the _request object. The variable below declares it as an open struct
// so that it can be referenced in expressions.
_request: {...}

// create some hidden fields for easy access to nested JSON paths and provide defaults
_composite: _request.observed.composite.resource
_compName:  _composite.metadata.name

_spec: _composite.spec
_tags: [
	if _composite.spec.parameters.tags != _|_ {_composite.spec.parameters.tags},
	{},
][0]
_suffixes: [
		if _spec.parameters.additionalSuffixes != _|_ {_spec.parameters.additionalSuffixes},
		[],
][0]
