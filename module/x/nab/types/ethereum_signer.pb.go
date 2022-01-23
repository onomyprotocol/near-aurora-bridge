// Code generated by protoc-gen-gogo. DO NOT EDIT.
// source: nab/v1/ethereum_signer.proto

package types

import (
	fmt "fmt"
	_ "github.com/gogo/protobuf/gogoproto"
	proto "github.com/gogo/protobuf/proto"
	math "math"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.GoGoProtoPackageIsVersion3 // please upgrade the proto package

// SignType defines messages that have been signed by an orchestrator
type SignType int32

const (
	SIGN_TYPE_UNSPECIFIED                          SignType = 0
	SIGN_TYPE_ORCHESTRATOR_SIGNED_MULTI_SIG_UPDATE SignType = 1
	SIGN_TYPE_ORCHESTRATOR_SIGNED_WITHDRAW_BATCH   SignType = 2
)

var SignType_name = map[int32]string{
	0: "SIGN_TYPE_UNSPECIFIED",
	1: "SIGN_TYPE_ORCHESTRATOR_SIGNED_MULTI_SIG_UPDATE",
	2: "SIGN_TYPE_ORCHESTRATOR_SIGNED_WITHDRAW_BATCH",
}

var SignType_value = map[string]int32{
	"SIGN_TYPE_UNSPECIFIED":                          0,
	"SIGN_TYPE_ORCHESTRATOR_SIGNED_MULTI_SIG_UPDATE": 1,
	"SIGN_TYPE_ORCHESTRATOR_SIGNED_WITHDRAW_BATCH":   2,
}

func (SignType) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_2976ae9ee735dbb0, []int{0}
}

func init() {
	proto.RegisterEnum("nab.v1.SignType", SignType_name, SignType_value)
}

func init() { proto.RegisterFile("nab/v1/ethereum_signer.proto", fileDescriptor_2976ae9ee735dbb0) }

var fileDescriptor_2976ae9ee735dbb0 = []byte{
	// 279 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0xe2, 0x92, 0xc9, 0x4b, 0x4c, 0xd2,
	0x2f, 0x33, 0xd4, 0x4f, 0x2d, 0xc9, 0x48, 0x2d, 0x4a, 0x2d, 0xcd, 0x8d, 0x2f, 0xce, 0x4c, 0xcf,
	0x4b, 0x2d, 0xd2, 0x2b, 0x28, 0xca, 0x2f, 0xc9, 0x17, 0x62, 0xcb, 0x4b, 0x4c, 0xd2, 0x2b, 0x33,
	0x94, 0x12, 0x49, 0xcf, 0x4f, 0xcf, 0x07, 0x0b, 0xe9, 0x83, 0x58, 0x10, 0x59, 0xad, 0xa9, 0x8c,
	0x5c, 0x1c, 0xc1, 0x99, 0xe9, 0x79, 0x21, 0x95, 0x05, 0xa9, 0x42, 0x92, 0x5c, 0xa2, 0xc1, 0x9e,
	0xee, 0x7e, 0xf1, 0x21, 0x91, 0x01, 0xae, 0xf1, 0xa1, 0x7e, 0xc1, 0x01, 0xae, 0xce, 0x9e, 0x6e,
	0x9e, 0xae, 0x2e, 0x02, 0x0c, 0x42, 0x46, 0x5c, 0x7a, 0x08, 0x29, 0xff, 0x20, 0x67, 0x0f, 0xd7,
	0xe0, 0x90, 0x20, 0xc7, 0x10, 0xff, 0xa0, 0x78, 0x90, 0xb0, 0xab, 0x4b, 0xbc, 0x6f, 0xa8, 0x4f,
	0x88, 0x27, 0x88, 0x13, 0x1f, 0x1a, 0xe0, 0xe2, 0x18, 0xe2, 0x2a, 0xc0, 0x28, 0x64, 0xc0, 0xa5,
	0x83, 0x5f, 0x4f, 0xb8, 0x67, 0x88, 0x87, 0x4b, 0x90, 0x63, 0x78, 0xbc, 0x93, 0x63, 0x88, 0xb3,
	0x87, 0x00, 0x93, 0x14, 0x47, 0xc7, 0x62, 0x39, 0x86, 0x15, 0x4b, 0xe4, 0x18, 0x9c, 0x22, 0x4e,
	0x3c, 0x92, 0x63, 0xbc, 0xf0, 0x48, 0x8e, 0xf1, 0xc1, 0x23, 0x39, 0xc6, 0x09, 0x8f, 0xe5, 0x18,
	0x2e, 0x3c, 0x96, 0x63, 0xb8, 0xf1, 0x58, 0x8e, 0x21, 0xca, 0x2e, 0x3d, 0xb3, 0x24, 0xa3, 0x34,
	0x49, 0x2f, 0x39, 0x3f, 0x57, 0x3f, 0x3f, 0x2f, 0x3f, 0xb7, 0x12, 0xec, 0x91, 0xe4, 0xfc, 0x1c,
	0xfd, 0xbc, 0xd4, 0xc4, 0x22, 0xdd, 0xc4, 0xd2, 0xa2, 0xfc, 0xa2, 0x44, 0xdd, 0xa4, 0xa2, 0xcc,
	0x94, 0xf4, 0x54, 0xfd, 0xdc, 0xfc, 0x94, 0xd2, 0x9c, 0x54, 0xfd, 0x0a, 0x7d, 0x50, 0x10, 0x95,
	0x54, 0x16, 0xa4, 0x16, 0x27, 0xb1, 0x81, 0xd5, 0x1b, 0x03, 0x02, 0x00, 0x00, 0xff, 0xff, 0xb6,
	0x8c, 0x53, 0xd7, 0x36, 0x01, 0x00, 0x00,
}
