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

package main

import (
	"flag"
	"fmt"
	"io"
	"os"

	"github.com/elastic/crossplane-function-cue/internal/cuetools"
	"github.com/pkg/errors"
	"github.com/spf13/cobra"
)

func openapiCommand() *cobra.Command {
	var pkg, dir, outFile string
	c := &cobra.Command{
		Use:   "openapi",
		Short: "generate self-contained openapi schemas for cue types",
		RunE: func(cmd *cobra.Command, args []string) error {
			cmd.SilenceUsage = true
			out, err := cuetools.GenerateOpenAPISchema(dir, pkg)
			if err != nil {
				return errors.Wrap(err, "generate schemas")
			}
			if outFile == "" || outFile == "." {
				fmt.Println(string(out))
				return nil
			}
			return os.WriteFile(outFile, out, 0o644)
		},
	}
	flags := c.Flags()
	flags.StringVar(&pkg, "pkg", "schemas", "package name of generated cue file")
	flags.StringVar(&dir, "dir", ".", "directory containing cue type definitions")
	flags.StringVar(&outFile, "out-file", "", "output file name, default is stdout")
	return c
}

func packageScriptCommand() *cobra.Command {
	var pkg, dir, outFile, out string
	c := &cobra.Command{
		Use:   "package-script",
		Short: "generate a self-contained script as text",
		RunE: func(cmd *cobra.Command, args []string) error {
			cmd.SilenceUsage = true
			out, err := cuetools.PackageScript(dir, cuetools.PackageScriptOpts{
				OutputPackage: pkg,
				Format:        cuetools.OutputFormat(out),
			})
			if err != nil {
				return errors.Wrap(err, "generate schemas")
			}
			if outFile == "" || outFile == "-" {
				fmt.Println(string(out))
				return nil
			}
			return os.WriteFile(outFile, out, 0o644)
		},
	}
	flags := c.Flags()
	flags.StringVar(&pkg, "pkg", "", "package name of generated cue file")
	flags.StringVar(&dir, "dir", ".", "directory containing cue type definitions")
	flags.StringVar(&outFile, "out-file", "", "output file name, default is stdout")
	flags.StringVarP(&out, "output", "o", string(cuetools.FormatCue), "output format, one of cue or raw")
	return c
}

func extractSchemaCommand() *cobra.Command {
	var pkg, file, outFile string
	c := &cobra.Command{
		Use:   "extract-schema",
		Short: "extract a cue schema from the openAPI spec of a CRD/XRD object",
		RunE: func(cmd *cobra.Command, args []string) error {
			cmd.SilenceUsage = true
			var reader io.Reader
			if file == "" || file == "-" {
				reader = os.Stdin
			} else {
				f, err := os.Open(file)
				if err != nil {
					return err
				}
				defer func() { _ = f.Close() }()
				reader = f
			}
			out, err := cuetools.ExtractSchema(reader, pkg)
			if err != nil {
				return errors.Wrap(err, "generate schemas")
			}
			if outFile == "" || outFile == "-" {
				fmt.Println(string(out))
				return nil
			}
			return os.WriteFile(outFile, out, 0o644)
		},
	}
	flags := c.Flags()
	flags.StringVar(&pkg, "pkg", "", "package name of generated cue file")
	flag.StringVar(&file, "file", "-", "input JSON or YAML file containing a single CRD/ XRD definition, defaults to stdin")
	flags.StringVar(&outFile, "out-file", "", "output file name, defaults to stdout")
	return c
}

func cueTestCommand() *cobra.Command {
	var p cuetools.TestConfig
	c := &cobra.Command{
		Use:   "cue-test",
		Short: "run unit tests for your composition implementation",
		RunE: func(cmd *cobra.Command, args []string) error {
			cmd.SilenceUsage = true
			tester, err := cuetools.NewTester(p)
			if err != nil {
				return err
			}
			return tester.Run()
		},
	}
	flags := c.Flags()
	flags.StringSliceVar(&p.TestTags, "test-tag", nil, "list of test tags to enable, one per test")
	flags.StringVar(&p.Package, "pkg", ".", "relative path to implementation package")
	flags.StringVar(&p.TestPackage, "test-pkg", "", "relative path to test package")
	flags.BoolVar(&p.Debug, "debug", false, "enable eval debugging")
	return c
}
