package compositions

import "list"

resources: list.Concat([xrds, compositions])

xrds: [
	for _, v in _xrds {v},
]

compositions: [
	for _, v in _compositions {v},
]
