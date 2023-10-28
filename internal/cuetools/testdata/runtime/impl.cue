package runtime

_request: {...}

resources: main: resource: {
	foo: _request.observed.composite.resource.foo
	bar: "baz"
}

