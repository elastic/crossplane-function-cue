package make_tool

import (
	"tool/cli"
	"tool/exec"
	"list"
	"strings"
)

// define some internal variables

k8sContext: *"docker-desktop" | string                     @tag(context)
ns:         *"claims" | string                             @tag(namespace)
image:      *"gotwarlost/crossplane-function-cue" | string @tag(image)
version:    *"latest" | string                             @tag(version)

libs: [
	"github.com/crossplane/crossplane/apis/apiextensions/v1",
	"github.com/crossplane/crossplane/apis/pkg/v1beta1",
	"github.com/crossplane/crossplane/apis/apiextensions/fn/proto/v1beta1",
	"github.com/elastic/crossplane-function-cue/pkg/input/v1beta1",
	"k8s.io/api/core/v1",
]

compositions: [
	"xs3bucket",
]

cmds: testList: list.FlattenN([
	for c in compositions {
		[
			"echo ' >' test: \(c)",
			"xp-function-cue cue-test ./platform/compositions/\(c)/runtime",
		]
	},
], 1)

cmds: scriptList: list.FlattenN([
	for c in compositions {
		["xp-function-cue package-script --pkg \(c) --out-file ./platform/compositions/\(c)/script.cue ./platform/compositions/\(c)/runtime"]
	},
], 1)

cmds: schemaGen:      "xp-function-cue openapi --pkg schemas --out-file=./shared/schemas/schemas.cue ./shared/api"
cmds: renderPlatform: "cue eval --out text -e yaml.MarshalStream(resources) -t image=\(image):\(version) ./platform/"
cmds: renderUser:     "cue eval --out text -e yaml.MarshalStream(resources) -t namespace=\(ns) ./user/"
cmds: k8sApply:       "kubectl apply --context=\(k8sContext) -f -"
cmds: fmt: [ "sh", "-c", "find . -name \\*cue | grep -v cue.mod | xargs dirname | sort -u | xargs cue fmt"]

// define commands

// shows available commands
command: help: {
	show: exec.Run & {cmd: [ "sh", "-c", "cue help cmd | grep -A100 'Available Commands:'"]}
}

// formats cue files
command: fmt: {
	show: exec.Run & {cmd: cmds.fmt}
}

// regenerates cue libraries for k8s and crossplane
command: lib: {
	_cmds: list.FlattenN([ for lib in libs {[ "cue get go \(lib)"]}], 1)
	_shellCmd: "\n" + strings.Join(_cmds, " && \\\n")

	rimraf: exec.Run & {cmd: [ "rm", "-rf", "./cue.mod/gen"]}
	log: cli.Print & {text: "regenerating cue libraries \(_shellCmd)", after: rimraf.$id}
	gen: exec.Run & {cmd: [ "sh", "-c", _shellCmd], after: log.$id}
}

// generates openAPI schemas for claim types
command: schemas: {
	log: cli.Print & {text: "regenerating openapi schemas\n\t\(cmds.schemaGen)"}
	genSchemas: exec.Run & {cmd: cmds.schemaGen}
}

_scriptCommand: strings.Join(cmds.scriptList, " && \\\n")

// packages scripts for compositions
command: scripts: {
	log: cli.Print & {text: "generating scripts\n\(_scriptCommand)"}
	genScript: exec.Run & {cmd: [ "sh", "-c", _scriptCommand], after: log.$id}
}

// generates k8s objects for the platform as YAML
command: platform: {
	genSchemas: exec.Run & {cmd: cmds.schemaGen}
	genScript: exec.Run & {cmd: [ "sh", "-c", _scriptCommand], after: genSchemas.$id}
	print: exec.Run & {cmd: cmds.renderPlatform, after: genScript.$id}
}

// applies k8s objects for the platform to the K8s cluster
command: "platform-apply": {
	genSchemas: exec.Run & {cmd: cmds.schemaGen}
	genScript: exec.Run & {cmd: [ "sh", "-c", _scriptCommand], after: genSchemas.$id}
	print: exec.Run & {cmd: cmds.renderPlatform, after: genScript.$id, stdout: string}
	apply: exec.Run & {cmd: cmds.k8sApply, stdin: print.stdout, after: print.$id}
}

// generates k8s object for the user (claims, namespaces etc.) as YAML
command: user: {
	print: exec.Run & {cmd: cmds.renderUser}
}

// applies claims and related objects to the K8s cluster
command: "user-apply": {
	print: exec.Run & {cmd: cmds.renderUser, stdout: string}
	apply: exec.Run & {cmd: cmds.k8sApply, stdin: print.stdout, after: print.$id}
}

// runs simple cue unit tests
command: tests: {
	run: exec.Run & {cmd: [ "sh", "-c", strings.Join(cmds.testList, " && \\\n")]}
}
