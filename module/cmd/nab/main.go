package main

import (
	"os"

	"github.com/cosmos/cosmos-sdk/server"
	"github.com/onomyprotocol/near-aurora-bridge/module/cmd/nab/cmd"
)

func main() {
	rootCmd, _ := cmd.NewRootCmd()
	if err := cmd.Execute(rootCmd); err != nil {
		switch e := err.(type) {
		case server.ErrorCode:
			os.Exit(e.Code)
		default:
			os.Exit(1)
		}
	}
}
