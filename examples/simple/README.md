# example-simple

This directory is the root of a fully-worked simple example that allows a user to create a
claim for one or more S3 buckets and get their endpoints and IAM policy.

The example is itself trivial but exercises an end-to-end solution that is
completely written in cue, including the generation of the claims interface, schemas, xrds, composition 
definitions, and the runtime code that returns composed objects.

While it is entirely possible to define all XRDs, functions, and compositions in YAML and only rely on cue
for the composition implementation, this approach fails to take into account the benefits of having
the entire code base in cue, and using schemas and validations everywhere.

This example goes overboard to define _everything_, include the `Makefile`, in cue.

## Quick start

| Command        | Description                                                     |
|----------------|-----------------------------------------------------------------|
| `cue cmd help` | see available commands                                          |
| `cue platform` | see the YAML for "platform" objects                             |
| `cue user`     | see the YAML for "user" objects                                 |
| `cue tests`    | run unit tests for compositions outside of a crossplane context | 

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
      * [xs3bucket](platform/compositions/xs3bucket/) - a specific composition definition
        * [runtime/](platform/compositions/xs3bucket/runtime) - the implementation of the composition function for the resource
          * [tests/](platform/compositions/xs3bucket/runtime/tests) - unit tests for the composition function at various stages of the managed object lifecycle
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

* You start by defining the api you want to expose. [example](shared/api/s3bucket.cue)
* You then use `cue cmd schemas` to generate the openAPI schemas corresponding to the cue types [example](shared/schemas/schemas.cue)
* You then define an XRD pulling in the types from the schema generated in the previous step. [example](platform/xrds.cue)
* You create the composition definition package and a runtime subpackage. 
  Initially you will just return an empty object from the implementation such that it is a noop. 
  [composition example](platform/compositions/xs3bucket/composition.cue). Note how it refers to a `_script` variable which will contain the script contents.
  Also it turns on debugging for the cue function pipeline such that you can see the inputs and outputs in the pod 
  logs for the cue function pod.
* You generate a `script.cue` file using `cue cmd scripts` to complete the composition definition.
* At this point, you can render platform objects using `cue platform` and apply them using `cue platform-apply`.
  You will get an XRD and composition against which you can write a claim.
* You create a namespace and a claim using `cue user-apply`. 
  This will start running the composition function and show you the inputs in the debug logs for the function pod.
* You can now use this input to see what exactly is available and write the composition implementation.
  You can develop this incrementally focusing on one managed resource at a time and iterate over it for multiple objects.

## Writing the composition implementation

The basic idea is get the request from the function runner and transform it to a set of managed resources.

* You start with an implementation that returns an empty object
* After applying the composition with debug turned on, you'll see the request object in the function pod logs
* Copy this locally and write your response based on what you see in this object. Start with one managed resource.
* Re-apply the composition with the new script and debug. 
* Rinse and repeat until all the functionality is present.

The nice thing about cue is how it unifies pieces of an object and puts them together.
This allows you to write a "module" (i.e. a separate file) for each resource that you want to compose. 

For example, the example implementation has self-contained files, one for creating the primary bucket and setting its 
ready state and status, one for the secondary buckets, and another for the IAM policy.

### Unit tests

`xp-function-cue` has a subcommand called `cue-test` that allows you to write unit tests for various inputs and outputs.
This is _extremely_ primitive but still very useful. 

This works as follows:

* Let's say the main package where you develop the composition is in `./runtime`
* You create a `tests` subdirectory under it
* Every test file is a cue file that is guarded by a `@if` tag which has the same name as the test file name. For example,
  a file called `initial.cue` will have a line called `@if(initial)` at the top of the file (*).
  This means that at any point only one file actually produces output based on the tag that is set.
* In this test file you define the `_request` object fully (by copying it from the pod logs) and write what the
  response to the request should be. You can copy the response from the function's pod logs as well if you have already
  implemented something and have manually checked the output.
* When you run `xp-function-cue cue-test --pkg ./runtime` it does the following:
  * creates a self-contained script from the `runtime` package just like `xp-function-cue package-script` would do.
  * figures out the tags for tests using the file names in the `tests/` subdirectory
  * for each such tag:
    * it evaluates the `tests` subdirectory with that tag turned on and extracts the `_request` object from it.
    * it does the same evaluation but now extracts the expected response as the full object that is returned
    * it runs the script with the `_request` object as obtained from the test and gets the actual result
    * it compares the expected and actual results using a YAML diff so that the differences are clearly visible.
* See the [examples](./platform/compositions/xs3bucket/runtime/tests) for more details.

(*) - the assumptions around tag names and the files they live in is antithetical to cue principles of "put whatever
you want anywhere". We'd like some cue experts to weigh in on how they would have approached the unit testing problem.

### On learning curves and bugs

Cue is an awesome language that feels like magic and makes it really easy to create complex output. Its ability
to consolidate all reachable definitions via `cue def --inline-imports` and create a sef-contained program is
amazing in concept. The unification of resources allow you to work piece-meal on different resources independently
without having to create a response as one giant object. Community support on the slack channel is also great.

That said there are still a few rough edges and bugs that can frustrate the cue composition writer and some hardening
is needed  :)

* It has a steep learning curve and meager documentation. The use-case that we use it for (getting a dynamic,
  mostly-schemaless object and turning it into a set of resources) is not a first-class use-case in the available docs.
* The functional programming paradigm takes getting used to.
* Conditional statements are extremely verbose requiring knowledge of [various patterns](https://cuetorials.com/patterns/).
  Unfortunately, for compositions, we need to use them quite a bit since what we emit depends on observed statuses of 
  various objects that change and may or may not even be available at different points in time.
  The [builtins proposal](https://github.com/cue-lang/cue/issues/943), when implemented, would go a long way in making 
  this much simpler to implement.
* The code needs to be hardened and has some bugs. Examples: [cue def](https://github.com/cue-lang/cue/issues/2648),
  [cue fmt](https://github.com/cue-lang/cue/issues/2646) 
