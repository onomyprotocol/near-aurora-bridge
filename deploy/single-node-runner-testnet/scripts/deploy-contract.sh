#!/bin/bash
set -eu

echo "running nab with bridge"

# Initial dir
CURRENT_WORKING_DIR=$(pwd)
# Name of the network to bootstrap
CHAINID="nab"
# Name of the nab artifact
NAB=nab
# The name of the nab node
NAB_NODE_NAME="nab"
# The prefix for cosmos addresses
NAB_ADDRESS_PREFIX="nab"
# The address to run nab node
NAB_HOST="0.0.0.0"
# The port of the nab gRPC
NAB_GRPC_PORT="9090"
# Home folder for nab config
NAB_HOME="$CURRENT_WORKING_DIR/$CHAINID/$NAB_NODE_NAME"
# Home flag for home folder
NAB_HOME_FLAG="--home $NAB_HOME"
# Onomy mnemonic used for fauset from (validator_key.json file)
NAB_VALIDATOR_MNEMONIC=$(jq -r .mnemonic $NAB_HOME/validator_key.json)
# near testnet address
ETH_ADDRESS="http://testnet.aurora.dev/"
# The ETH key used for orchestrator signing of the transactions
ETH_ORCHESTRATOR_PRIVATE_KEY=c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709

# ------------------ Run nab ------------------

echo "Starting $NAB_NODE_NAME"
$NAB $NAB_HOME_FLAG start --pruning=nothing &

echo "Waiting $NAB_NODE_NAME to launch gRPC $NAB_GRPC_PORT..."

while ! timeout 1 bash -c "</dev/tcp/$NAB_HOST/$NAB_GRPC_PORT"; do
  sleep 1
done

echo "$NAB_NODE_NAME launched"

#-------------------- Deploy the contract --------------------

echo "Deploying Gravity contract"
cd /root/home/contracts/

contract-deployer \
--cosmos-node="http://$NAB_HOST:26657" \
--eth-node="$ETH_ADDRESS" \
--eth-privkey="$ETH_ORCHESTRATOR_PRIVATE_KEY" \
--contract=Gravity.json \
--test-mode=true