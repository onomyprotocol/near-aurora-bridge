package types

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/msgservice"
)

// ModuleCdc is the codec for the module
var ModuleCdc = codec.NewLegacyAmino()

func init() {
	RegisterCodec(ModuleCdc)
}

//nolint: exhaustivestruct
// RegisterInterfaces registers the interfaces for the proto stuff
func RegisterInterfaces(registry types.InterfaceRegistry) {
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgValsetConfirm{},
		&MsgSendToEth{},
		&MsgRequestBatch{},
		&MsgConfirmBatch{},
		&MsgConfirmLogicCall{},
		&MsgSendToCosmosClaim{},
		&MsgBatchSendToEthClaim{},
		&MsgERC20DeployedClaim{},
		&MsgSetOrchestratorAddress{},
		&MsgLogicCallExecutedClaim{},
		&MsgValsetUpdatedClaim{},
		&MsgCancelSendToEth{},
		&MsgSubmitBadSignatureEvidence{},
	)

	registry.RegisterInterface(
		"nab.v1beta1.EthereumClaim",
		(*EthereumClaim)(nil),
		&MsgSendToCosmosClaim{},
		&MsgBatchSendToEthClaim{},
		&MsgERC20DeployedClaim{},
		&MsgLogicCallExecutedClaim{},
		&MsgValsetUpdatedClaim{},
	)

	registry.RegisterInterface("nab.v1beta1.EthereumSigned", (*EthereumSigned)(nil), &Valset{}, &OutgoingTxBatch{}, &OutgoingLogicCall{})

	msgservice.RegisterMsgServiceDesc(registry, &_Msg_serviceDesc)
}

//nolint: exhaustivestruct
// RegisterCodec registers concrete types on the Amino codec
func RegisterCodec(cdc *codec.LegacyAmino) {
	cdc.RegisterInterface((*EthereumClaim)(nil), nil)
	cdc.RegisterConcrete(&MsgSetOrchestratorAddress{}, "nab/MsgSetOrchestratorAddress", nil)
	cdc.RegisterConcrete(&MsgValsetConfirm{}, "nab/MsgValsetConfirm", nil)
	cdc.RegisterConcrete(&MsgSendToEth{}, "nab/MsgSendToEth", nil)
	cdc.RegisterConcrete(&MsgRequestBatch{}, "nab/MsgRequestBatch", nil)
	cdc.RegisterConcrete(&MsgConfirmBatch{}, "nab/MsgConfirmBatch", nil)
	cdc.RegisterConcrete(&MsgConfirmLogicCall{}, "nab/MsgConfirmLogicCall", nil)
	cdc.RegisterConcrete(&Valset{}, "nab/Valset", nil)
	cdc.RegisterConcrete(&MsgSendToCosmosClaim{}, "nab/MsgSendToCosmosClaim", nil)
	cdc.RegisterConcrete(&MsgBatchSendToEthClaim{}, "nab/MsgBatchSendToEthClaim", nil)
	cdc.RegisterConcrete(&MsgERC20DeployedClaim{}, "nab/MsgERC20DeployedClaim", nil)
	cdc.RegisterConcrete(&MsgLogicCallExecutedClaim{}, "nab/MsgLogicCallExecutedClaim", nil)
	cdc.RegisterConcrete(&MsgValsetUpdatedClaim{}, "nab/MsgValsetUpdatedClaim", nil)
	cdc.RegisterConcrete(&OutgoingTxBatch{}, "nab/OutgoingTxBatch", nil)
	cdc.RegisterConcrete(&MsgCancelSendToEth{}, "nab/MsgCancelSendToEth", nil)
	cdc.RegisterConcrete(&OutgoingTransferTx{}, "nab/OutgoingTransferTx", nil)
	cdc.RegisterConcrete(&ERC20Token{}, "nab/ERC20Token", nil)
	cdc.RegisterConcrete(&IDSet{}, "nab/IDSet", nil)
	cdc.RegisterConcrete(&Attestation{}, "nab/Attestation", nil)
	cdc.RegisterConcrete(&MsgSubmitBadSignatureEvidence{}, "nab/MsgSubmitBadSignatureEvidence", nil)
}
