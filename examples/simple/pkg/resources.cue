package pkg

import (
	"list"
	libComp "cue-functions.io/examples/simple/pkg/compositions"
)

functions: [
	for _, v in _functions {v},
]

xrds:         libComp.xrds
compositions: libComp.compositions

all: list.Concat([
	functions,
	xrds,
	compositions,
])
