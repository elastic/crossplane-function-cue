package runtime

import (
	"list"
)

// implementation note: all internal top-level variables should be defined in this file because of
// https://github.com/cue-lang/cue/issues/2648

// responses should be generated based on the _request object. The variable below declares it as an open struct
// so that it can be referenced in expressions.
_request: {...}

// create some hidden fields for easy access to nested JSON paths and provide defaults
_composite: _request.observed.composite.resource
_spec:      _composite.spec
_tags:      [
		if _composite.spec.parameters.tags != _|_ {_composite.spec.parameters.tags},
		{},
][0]
_suffixes: [
		if _spec.parameters.additionalSuffixes != _|_ {s: _spec.parameters.additionalSuffixes},
		{s: []},
][0].s

// #listWithDefault returns a list guaranteed to have a specific element at its end. The input list
// may not be present but if it is, must be a real list.
// use as: (#listWithDefault & { in: some.path.to.list, def: { "foo": "bar" } }).out
#listWithDefault: {
	x=in:  _ // input list or bottom
	y=def: _ // a default value that will be at the end of the output list whether in is valid or not
	out:   [ // out is a list which is either a valid input list concatenated with a default value, or a list with a single default element
		if x != _|_ {list.Concat([x, [y]])},
		[y],
	][0]
}

#readyValue: {
	x=in:            _
	y = _tmp:        (#listWithDefault & {in: x, def: {type: "Ready", status: "Unknown"}}).out
	z = _readyValue: [ for r in y if r.type == "Ready" {r.status}][0]
	out:             [
				if z == "True" {ready:  "READY_TRUE"},
				if z == "False" {ready: "READY_FALSE"},
				{ready:                 "READY_UNSPECIFIED"},
	][0].ready
}
