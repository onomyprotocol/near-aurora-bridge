#!/bin/bash
set -eu

NEAR_HOST="127.0.0.1"
NEAR_PORT="3030"
NEAR_MASTER_ACCOUNT="node0"
AURORA_ACCOUNT="aurora.$NEAR_MASTER_ACCOUNT"

nearup run localnet &

echo "Waiting for near to launch  and open the $NEAR_HOST:$NEAR_PORT"

while ! timeout 1 bash -c "</dev/tcp/$NEAR_HOST/$NEAR_PORT"; do
  sleep 3
done

echo "Near is ready"

echo "Setting up aurora on localnet"

echo "Creating aurora account on near"
export NEAR_ENV=local
near create-account $AURORA_ACCOUNT --master-account $NEAR_MASTER_ACCOUNT --initial-balance 100000 --keyPath ~/.near/localnet/$NEAR_MASTER_ACCOUNT/validator_key.json

echo "Deploying aurora for account $AURORA_ACCOUNT"

export NEAR_ENV=local
near deploy --account-id $AURORA_ACCOUNT --wasm-file=/assets/mainnet-release.wasm --keyPath ~/.near/localnet/$NEAR_MASTER_ACCOUNT/validator_key.json

aurora -d -v initialize --chain 1313161556 --engine $AURORA_ACCOUNT --owner $NEAR_MASTER_ACCOUNT --signer $AURORA_ACCOUNT

echo "Inspection the aurora node"

aurora get-version --engine $AURORA_ACCOUNT
aurora get-owner --engine $AURORA_ACCOUNT
aurora get-chain-id --engine $AURORA_ACCOUNT

cd  ~/.nearup/logs/localnet/
tail -f node0.log  node1.log  node2.log  node3.log