#!/bin/bash
set -eu

echo "building environment"

# Initial dir
CURRENT_WORKING_DIR=$(pwd)
# Name of the network to bootstrap
CHAINID="testchain"
# Name of the gravity artifact
GRAVITY=gravity
# The name of the gravity node
GRAVITY_NODE_NAME="gravity"
# The address to run gravity node
GRAVITY_HOST="0.0.0.0"
# The port of the gravity gRPC
GRAVITY_GRPC_PORT="9090"
# Home folder for gravity config
GRAVITY_HOME="$CURRENT_WORKING_DIR/$CHAINID/$GRAVITY_NODE_NAME"
# Home flag for home folder
GRAVITY_HOME_FLAG="--home $GRAVITY_HOME"

# This key is the private key for the public key defined in ETHGenesis.json
# where the full node / miner sends its rewards. Therefore it's always going
# to have a lot of ETH to pay for things like contract deployments
ETH_MINER_PRIVATE_KEY=e0b21b1d80e53f38734a3ed395796956b50c637916ddbb6cedb096b848053d2d
ETH_MINER_PUBLIC_KEY=0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0

# The host of ethereum node
ETH_HOST="0.0.0.0"
# Eth node rpc port
ETH_RPC_PORT="8545"

#-------------------- Run gravity node --------------------

echo "Starting $GRAVITY_NODE_NAME"
$GRAVITY $GRAVITY_HOME_FLAG start --pruning=nothing &

echo "Waiting $GRAVITY_NODE_NAME to launch gRPC $GRAVITY_GRPC_PORT..."

while ! timeout 1 bash -c "</dev/tcp/$GRAVITY_HOST/$GRAVITY_GRPC_PORT"; do
  sleep 1
done

echo "$GRAVITY_NODE_NAME launched"

#-------------------- Run ethereum (geth/rinkeby) --------------------

geth --rinkeby --syncmode "light" \
                               --http \
                               --http.port $ETH_RPC_PORT \
                               --http.addr $ETH_HOST \
                               --http.corsdomain "*" \
                               --http.vhosts "*" \
                               &

GETH_IPC_PATH="/root/.ethereum/rinkeby/geth.ipc"
GETH_CONSOLE="geth --rinkeby attach ipc:$GETH_IPC_PATH console --exec"

# 600 sec to run light node
for i in {1..600}; do
  sleep 1
  echo "attempt $i to start the eth node"

  netPeerCount=$($GETH_CONSOLE "net.peerCount")
  if [ "$netPeerCount" -lt 3  ]; then
     echo "net.peerCount : $netPeerCount"
     continue
  fi

  ethSyncing=$($GETH_CONSOLE "eth.syncing")
  if [ "$ethSyncing" != "false"  ]; then
     echo "eth.syncing : $ethSyncing"
     continue
  fi

  if [ $i -eq 600 ]; then
     echo "timeout for ethereum light node exceed"
     exit
  fi

  break
done
set -e

echo "ethereum light node is ready, peers: $($GETH_CONSOLE "net.peerCount")"

#-------------------- Apply ethereum contract --------------------

echo "account coins: $(geth --rinkeby attach ipc:/root/.ethereum/rinkeby/geth.ipc console --exec "web3.eth.getBalance('$ETH_MINER_PUBLIC_KEY')")"

echo "Applying contracts"

GRAVITY_DIR=/go/src/github.com/onomyprotocol/cosmos-gravity-bridge/
cd $GRAVITY_DIR/solidity

npx ts-node \
    contract-deployer.ts \
    --cosmos-node="http://$GRAVITY_HOST:26657" \
    --eth-node="http://$ETH_HOST:$ETH_RPC_PORT" \
    --eth-privkey="$ETH_MINER_PRIVATE_KEY" \
    --contract=artifacts/contracts/Gravity.sol/Gravity.json \
    --test-mode=false | grep "Gravity deployed at Address" | grep -Eow '0x[0-9a-fA-F]{40}' >> $GRAVITY_HOME/eth_contract_address

CONTRACT_ADDRESS=$(cat $GRAVITY_HOME/eth_contract_address)

echo "Contract address: $CONTRACT_ADDRESS"