#!/bin/bash
set -eu

echo "building environment"

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
# Home folder for nab config
NAB_HOME="$CURRENT_WORKING_DIR/$CHAINID/$NAB_NODE_NAME"
# Home flag for home folder
NAB_HOME_FLAG="--home $NAB_HOME"
# Config directories for nab node
NAB_HOME_CONFIG="$NAB_HOME/config"
# Config file for nab node
NAB_NODE_CONFIG="$NAB_HOME_CONFIG/config.toml"
# App config file for nab node
NAB_APP_CONFIG="$NAB_HOME_CONFIG/app.toml"
# Keyring flag
NAB_KEYRING_FLAG="--keyring-backend test"
# Chain ID flag
NAB_CHAINID_FLAG="--chain-id $CHAINID"
# The name of the nab validator
NAB_VALIDATOR_NAME=val
# The name of the nab orchestrator/validator
NAB_ORCHESTRATOR_NAME=orch
# Gravity chain demons
STAKE_DENOM="stake"
NORMAL_DENOM="samoleans"
# The ethereum address on validator/orchestrator
ETH_ORCHESTRATOR_VALIDATOR_ADDRESS=0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d

# ------------------ Init nab ------------------

echo "Creating $NAB_NODE_NAME validator with chain-id=$CHAINID..."
echo "Initializing genesis files"

# Build genesis file incl account for passed address
NAB_GENESIS_COINS="100000000000$STAKE_DENOM,100000000000$NORMAL_DENOM"

# Initialize the home directory and add some keys
echo "Init test chain"
$NAB $NAB_HOME_FLAG $NAB_CHAINID_FLAG init $NAB_NODE_NAME
echo "Add validator key"
$NAB $NAB_HOME_FLAG keys add $NAB_VALIDATOR_NAME $NAB_KEYRING_FLAG --output json | jq . >> $NAB_HOME/validator_key.json
echo "Adding validator addresses to genesis files"
$NAB $NAB_HOME_FLAG add-genesis-account "$($NAB $NAB_HOME_FLAG keys show $NAB_VALIDATOR_NAME -a $NAB_KEYRING_FLAG)" $NAB_GENESIS_COINS
echo "Generating orchestrator keys"
$NAB $NAB_HOME_FLAG keys add --dry-run=true --output=json $NAB_ORCHESTRATOR_NAME | jq . >> $NAB_HOME/orchestrator_key.json

echo "Adding orchestrator keys to genesis"
NAB_ORCHESTRATOR_KEY="$(jq .address $NAB_HOME/orchestrator_key.json)"

jq ".app_state.auth.accounts += [{\"@type\": \"/cosmos.auth.v1beta1.BaseAccount\",\"address\": $NAB_ORCHESTRATOR_KEY,\"pub_key\": null,\"account_number\": \"0\",\"sequence\": \"0\"}]" $NAB_HOME_CONFIG/genesis.json | sponge $NAB_HOME_CONFIG/genesis.json
jq ".app_state.bank.balances += [{\"address\": $NAB_ORCHESTRATOR_KEY,\"coins\": [{\"denom\": \"$NORMAL_DENOM\",\"amount\": \"100000000000\"},{\"denom\": \"$STAKE_DENOM\",\"amount\": \"100000000000\"}]}]" $NAB_HOME_CONFIG/genesis.json | sponge $NAB_HOME_CONFIG/genesis.json

echo "Creating gentxs"
$NAB $NAB_HOME_FLAG gentx --ip $NAB_HOST $NAB_VALIDATOR_NAME 100000000000$STAKE_DENOM "$ETH_ORCHESTRATOR_VALIDATOR_ADDRESS" "$(jq -r .address $NAB_HOME/orchestrator_key.json)" $NAB_KEYRING_FLAG $NAB_CHAINID_FLAG

echo "Collecting gentxs in $NAB_NODE_NAME"
$NAB $NAB_HOME_FLAG collect-gentxs

echo "Exposing ports and APIs of the $NAB_NODE_NAME"
# Switch sed command in the case of linux
fsed() {
  if [ `uname` = 'Linux' ]; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

# Change ports
fsed "s#\"tcp://127.0.0.1:26656\"#\"tcp://$NAB_HOST:26656\"#g" $NAB_NODE_CONFIG
fsed "s#\"tcp://127.0.0.1:26657\"#\"tcp://$NAB_HOST:26657\"#g" $NAB_NODE_CONFIG
fsed 's#addr_book_strict = true#addr_book_strict = false#g' $NAB_NODE_CONFIG
fsed 's#external_address = ""#external_address = "tcp://'$NAB_HOST:26656'"#g' $NAB_NODE_CONFIG
fsed 's#enable = false#enable = true#g' $NAB_APP_CONFIG
fsed 's#swagger = false#swagger = true#g' $NAB_APP_CONFIG
