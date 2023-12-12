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
	"os"

	"github.com/crossplane/function-sdk-go"
	"github.com/elastic/crossplane-function-cue/internal/fn"
	"github.com/spf13/cobra"
)

type serverParams struct {
	fn.Options
	network     string
	address     string
	tlsCertsDir string
	insecure    bool
}

func serverCommand() *cobra.Command {
	p := serverParams{
		network:     "tcp",
		address:     ":9443",
		tlsCertsDir: os.Getenv("TLS_SERVER_CERTS_DIR"),
	}
	c := &cobra.Command{
		Use:   "server",
		Short: "runs the cue function implementation as a gRPC server",
		RunE: func(cmd *cobra.Command, args []string) error {
			var err error
			p.Logger, err = function.NewLogger(p.Debug)
			if err != nil {
				return err
			}
			runner, err := fn.New(p.Options)
			if err != nil {
				return err
			}
			return function.Serve(
				runner,
				function.Listen(p.network, p.address),
				function.MTLSCertificates(p.tlsCertsDir),
				function.Insecure(p.insecure),
			)
		},
	}
	flags := c.Flags()
	flags.StringVar(&p.network, "network", p.network, "network on which to listen on")
	flags.StringVar(&p.address, "address", p.address, "address on which to listen on")
	flags.StringVar(&p.tlsCertsDir, "tls-server-certs-dir", p.tlsCertsDir, "directory containing server certs (tls.key, tls.crt) and the CA used to verify client certificates (ca.crt), defaulted from TLS_SERVER_CERTS_DIR")
	flags.BoolVarP(&p.Debug, "debug", "d", p.Debug, "enable debug logging")
	flags.BoolVar(&p.insecure, "insecure", p.insecure, "run without mTLS credentials. If you supply this flag --tls-server-certs-dir will be ignored.")
	return c
}
