package app

import (
	"github.com/cosmos/cosmos-sdk/std"
	nabparams "github.com/onomyprotocol/near-aurora-bridge/module/app/params"
)

// MakeEncodingConfig creates an EncodingConfig for gravity.
func MakeEncodingConfig() nabparams.EncodingConfig {
	encodingConfig := nabparams.MakeEncodingConfig()
	std.RegisterLegacyAminoCodec(encodingConfig.Amino)
	std.RegisterInterfaces(encodingConfig.InterfaceRegistry)
	ModuleBasics.RegisterLegacyAminoCodec(encodingConfig.Amino)
	ModuleBasics.RegisterInterfaces(encodingConfig.InterfaceRegistry)
	return encodingConfig
}
