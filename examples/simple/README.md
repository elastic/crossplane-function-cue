# example-simple

This directory is the root of a fully-worked simple example that allows a user to create a
claim for one or more S3 buckets and get their endpoints and IAM policy.

The example is itself trivial but exercises an end-to-end solution that is
completely written in cue, including the generation of the claims interface, schemas, xrds, composition 
definitions, and the runtime code that returns composed objects.

While it is entirely possible to define all XRDs, functions, and compositions in YAML and only rely on cue
for the composition implementation, this approach fails to take into account the benefits of having
the entire code base in cue, and using schemas and validations everywhere.

This example goes overboard to define _everything_, include the `Makefile`, in cue. Try `cue cmd help` to
see what's available.

## Directory structure

* [cue.mod](cue.mod/) - contains the module definition and the required cue libraries for crossplane, k8s, as cue
  schemas, populated via `cue get go`).
* [shared](shared/) - shared libraries for use
  * [api](shared/api/) - has the schema for the user facing types (i.e. what the user needs to set in a claim). Since types
  and values look the same in cue, it also serves as an example of the input the user can provide.
  * [gvk](shared/gvk/) - contains a cue package with constants for group-version-kinds for various custom resources.
  * [schemas](shared/schemas) - contains the openAPI schema generated from the api using `xp-function-cue openapi`.
* [platform](platform/) - contains the resources for the "platform implementation" - i.e. the XRDs, function definitions,
  composition definitions and their implementation.
    * [compositions](platform/compositions/) - returns an aggregate of composition objects
      * &lt;resource&gt; - a specific composition resource [example](platform/compositions/xs3bucket/)
        * runtime - the implementation of the composition function for the resource  
* [user](user/) - the "user" objects like namespaces and test claims.

In addition:

* [make_tool.cue](make_tool.cue) has commands to generates schemas, self-contained cue scripts as the function
implementation, and the ability to render and apply k8s resources for both the platform and user types. The shell 
commands used in the tool package can be found near the top of the file.

* [schema.go](schema.go) contains blank imports for all external types that are pulled in using `cue get go` - the versions of these
  external dependencies are declared in the [go.mod](go.mod) file. This way you can always use `go mod tidy` in this
  directory.

## Some conventions

* Any package containing a file called `index.cue` returns an object of the form `{ resources: [ list, of, k8s, objects] }`
  which can be rendered as YAML and applied to a K8s cluster.
* Composition implementations are defined in a package called `runtime` under its composition definition. The implementation
  can span multiple files and refer to external packages as needed.
* The `script.cue` file in the directory for a composition definition is generated as a single self-contained script from
  the implementation package contents.

## Soup to nuts

* You start by defining the api you want to expose. [example](api/s3bucket.cue)
* You then use `cue cmd schemas` to generate the openAPI schemas corresponding to the cue types [example](shared/schemas/schemas.cue)
* You then define an XRD pulling in the types from the schema generated in the previous step. [example](platform/xrds.cue)
* You create the composition definition package and a runtime subpackage. 
  Initially you will just return an empty object from the implementation such that it is a noop. 
  [composition example](platform/compositions/xs3bucket/composition.cue). Note how it refers to a `_script` variable which will contain the script contents.
  Also it turns on debugging for the cue function pipeline such that you can see the inputs and outputs in the pod 
  logs for the cue function pod.
* You generate a `script.cue` file using `cue cmd scripts` to complete the composition definition.
* At this point, you can render platform objects using `cue cmd platform` and apply them using `cue cmd platform-apply`.
  You will get an XRD and composition against which you can write a claim.
* You create a namespace and a claim using `cue cmd user-apply`. 
  This will start running the composition function and show you the inputs in the debug logs for the function pod.
* You can now use this input to see what exactly is available and write the composition implementation.
  You can develop this incrementally focusing on one managed resource at a time and iterate over it for multiple objects.

## Writing the composition implementation

The basic idea is get the request from the function runner and transform it to a set of managed resources.

TODO: 

* explain some more and show how simple unit tests can be written using `@if(some_test)` tags and `cue eval -t some_test` invocations. 

* Talk about the complexity of conditional logic in cue and how the proposed builtins, when available, can make the code
simpler in the future.

* Also warn people of [cue def bugs](https://github.com/cue-lang/cue/issues/2648) when the code is consolidated and
inlined.
