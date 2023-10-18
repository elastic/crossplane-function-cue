// Licensed to Elasticsearch B.V. under one or more contributor
// license agreements. See the NOTICE file distributed with
// this work for additional information regarding copyright
// ownership. Elasticsearch B.V. licenses this file to you under
// the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

package fn

import (
	"context"
	"fmt"
	"log"

	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/format"
	"github.com/crossplane/crossplane-runtime/pkg/logging"
	"github.com/crossplane/function-sdk-go"
	fnv1beta1 "github.com/crossplane/function-sdk-go/proto/v1beta1"
	"github.com/crossplane/function-sdk-go/request"
	"github.com/crossplane/function-sdk-go/response"
	input "github.com/elastic/crossplane-function-cue/pkg/input/v1beta1"
	"github.com/pkg/errors"
	"google.golang.org/protobuf/encoding/protojson"
)

// Options are options for the cue runner.
type Options struct {
	Logger logging.Logger
	Debug  bool
}

// Cue runs cue scripts that adhere to a specific interface.
type Cue struct {
	fnv1beta1.UnimplementedFunctionRunnerServiceServer
	log   logging.Logger
	debug bool
}

// New creates a cue runner.
func New(opts Options) (*Cue, error) {
	if opts.Logger == nil {
		var err error
		opts.Logger, err = function.NewLogger(opts.Debug)
		if err != nil {
			return nil, err
		}
	}
	return &Cue{
		log:   opts.Logger,
		debug: opts.Debug,
	}, nil
}

// DebugOptions are per-eval debug options.
type DebugOptions struct {
	Enabled bool // enable input/ output debugging
	Raw     bool // do not remove any "noise" attributes in the input object
	Script  bool // render the final script as a debug output
}

// Eval evaluates the supplied script with an additional _request object using the supplied request and returns the
// response as a State message.
func (f *Cue) Eval(in *fnv1beta1.RunFunctionRequest, script string, debug DebugOptions) (*fnv1beta1.State, error) {
	// input request only contains properties as documented in the interface, not the whole object
	req := &fnv1beta1.RunFunctionRequest{
		Observed: in.GetObserved(),
		Desired:  in.GetDesired(),
		Context:  in.GetContext(),
	}
	// extract request as object
	reqBytes, err := protojson.MarshalOptions{Indent: "  "}.Marshal(req)
	if err != nil {
		return nil, errors.Wrap(err, "proto json marshal")
	}

	preamble := "_request: "
	if debug.Enabled {
		log.Printf("[request:begin]\n%s %s\n[request:end]\n", preamble, f.getDebugString(reqBytes, debug.Raw))
	}

	// format the additional input for now, should not be needed in production
	code, err := format.Source([]byte(preamble+string(reqBytes)), format.TabIndent(false), format.UseSpaces(2))
	if err != nil {
		return nil, errors.Wrap(err, "format generated code")
	}

	// evaluate the script with the added _request variable
	finalScript := script + "\n" + string(code)
	if debug.Script {
		log.Printf("[script:begin]\n%s\n[script:end]\n", finalScript)
	}

	runtime := cuecontext.New()
	val := runtime.CompileBytes([]byte(finalScript))
	if val.Err() != nil {
		return nil, errors.Wrap(val.Err(), "compile cue code")
	}
	resBytes, err := val.MarshalJSON() // this can fail if value is not concrete
	if err != nil {
		return nil, errors.Wrap(err, "marshal cue output")
	}
	if debug.Enabled {
		log.Printf("[response:begin]\n%s\n[response:end]\n", f.getDebugString(resBytes, debug.Raw))
	}

	var ret fnv1beta1.State
	err = protojson.Unmarshal(resBytes, &ret)
	if err != nil {
		return nil, errors.Wrap(err, "unmarshal cue output using proto json")
	}
	return &ret, nil
}

// RunFunction runs the function. It expects a single script that is complete except for a `_request`
// variable that the function runner supplies.
func (f *Cue) RunFunction(_ context.Context, req *fnv1beta1.RunFunctionRequest) (outRes *fnv1beta1.RunFunctionResponse, finalErr error) {
	tag := req.GetMeta().GetTag()
	if tag == "" {
		tag = "<unknown>"
	}
	logger := f.log.WithValues("tag", tag)
	logger.Info("Running Function")

	// setup response with desired state set up upstream functions
	res := response.To(req, response.DefaultTTL)

	// automatically handle errors and response logging
	defer func() {
		if finalErr == nil {
			f.log.Info("cue module executed successfully")
			response.Normal(outRes, "cue module executed successfully")
			return
		}
		f.log.Info(finalErr.Error())
		response.Fatal(res, finalErr)
		outRes = res
	}()

	// get inputs
	in := &input.CueFunctionParams{}
	if err := request.GetInput(req, in); err != nil {
		return nil, errors.Wrap(err, "unable to get input")
	}
	if in.Spec.Script == "" {
		return nil, fmt.Errorf("input script was not specified")
	}

	state, err := f.Eval(req, in.Spec.Script, DebugOptions{
		Enabled: f.debug || in.Spec.Debug,
		Raw:     in.Spec.DebugRaw,
		Script:  in.Spec.DebugScript,
	})
	if err != nil {
		return res, errors.Wrap(err, "eval script")
	}
	return f.mergeResponse(res, state), nil
}

func (f *Cue) mergeResponse(res *fnv1beta1.RunFunctionResponse, desired *fnv1beta1.State) *fnv1beta1.RunFunctionResponse {
	// selectively add returned resources without deleting any previous desired state
	if res.Desired == nil {
		res.Desired = &fnv1beta1.State{}
	}
	if res.Desired.Resources == nil {
		res.Desired.Resources = map[string]*fnv1beta1.Resource{}
	}
	// only set desired composite if the cue script actually returns it
	if desired.GetComposite() != nil {
		res.Desired.Composite = desired.GetComposite()
	}
	// set desired resources from cue output
	for k, v := range desired.GetResources() {
		res.Desired.Resources[k] = v
	}
	return res
}
