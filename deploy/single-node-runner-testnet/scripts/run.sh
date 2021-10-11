#!/bin/bash
set -eu

echo "running near-aurora-bridge"

# Initial dir
CURRENT_WORKING_DIR=$(pwd)
# Name of the network to bootstrap
CHAINID="nab"
# Name of the nab artifact
NAB=nab
# The name of the nab node
NAB_NODE_NAME="nab"
# The address to run nab node
NAB_HOST="0.0.0.0"
# The port of the nab gRPC
NAB_GRPC_PORT="9090"
# Home folder for nab config
NAB_HOME="$CURRENT_WORKING_DIR/$CHAINID/$NAB_NODE_NAME"
# Home flag for home folder
NAB_HOME_FLAG="--home $NAB_HOME"
# Gravity mnemonic used for orchestrator signing of the transactions (orchestrator_key.json file)
NAB_ORCHESTRATOR_MNEMONIC=$(jq -r .mnemonic $NAB_HOME/orchestrator_key.json)

# Gravity chain demons
STAKE_DENOM="stake"

# The ETH key used for orchestrator signing of the transactions
ETH_ORCHESTRATOR_PRIVATE_KEY=c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709

# The host of ethereum node
ETH_HOST="0.0.0.0"
# Eth node rpc port
ETH_RPC_PORT="8545"
# near testnet address
ETH_ADDRESS="http://testnet.aurora.dev/"

ETH_CONTRACT_ADDRESS=0x10997aca2B4a7965f09C87D32f09334D33B75c3f

# ------------------ Run nab ------------------

echo "Starting $NAB_NODE_NAME"
$NAB $NAB_HOME_FLAG start --pruning=nothing &

echo "Waiting $NAB_NODE_NAME to launch gRPC $NAB_GRPC_PORT..."

while ! timeout 1 bash -c "</dev/tcp/$NAB_HOST/$NAB_GRPC_PORT"; do
  sleep 1
done

echo "$NAB_NODE_NAME launched"

#-------------------- Run orchestrator --------------------

echo "Starting orchestrator"

gbt orchestrator --cosmos-phrase="$NAB_ORCHESTRATOR_MNEMONIC" \
             --ethereum-key="$ETH_ORCHESTRATOR_PRIVATE_KEY" \
             --cosmos-grpc="http://$NAB_HOST:$NAB_GRPC_PORT/" \
             --ethereum-rpc="$ETH_ADDRESS" \
             --fees="1$STAKE_DENOM" \
             --gravity-contract-address="$ETH_CONTRACT_ADDRESS"