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
# Home folder for gravity config
GRAVITY_HOME="$CURRENT_WORKING_DIR/$CHAINID/$GRAVITY_NODE_NAME"
# Home flag for home folder
GRAVITY_HOME_FLAG="--home $GRAVITY_HOME"
# Config directories for gravity node
GRAVITY_HOME_CONFIG="$GRAVITY_HOME/config"
# Config file for gravity node
GRAVITY_NODE_CONFIG="$GRAVITY_HOME_CONFIG/config.toml"
# App config file for gravity node
GRAVITY_APP_CONFIG="$GRAVITY_HOME_CONFIG/app.toml"
# Keyring flag
GRAVITY_KEYRING_FLAG="--keyring-backend test"
# Chain ID flag
GRAVITY_CHAINID_FLAG="--chain-id $CHAINID"
# The name of the gravity validator
GRAVITY_VALIDATOR_NAME=val
# The name of the gravity orchestrator/validator
GRAVITY_ORCHESTRATOR_NAME=orch
# Gravity chain demons
STAKE_DENOM="stake"
NORMAL_DENOM="samoleans"
# The ethereum address on validator/orchestrator
ETH_ORCHESTRATOR_VALIDATOR_ADDRESS=0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d

# ------------------ Init gravity ------------------

echo "Creating $GRAVITY_NODE_NAME validator with chain-id=$CHAINID..."
echo "Initializing genesis files"

# Build genesis file incl account for passed address
GRAVITY_GENESIS_COINS="100000000000$STAKE_DENOM,100000000000$NORMAL_DENOM"

# Initialize the home directory and add some keys
echo "Init test chain"
$GRAVITY $GRAVITY_HOME_FLAG $GRAVITY_CHAINID_FLAG init $GRAVITY_NODE_NAME
echo "Add validator key"
$GRAVITY $GRAVITY_HOME_FLAG keys add $GRAVITY_VALIDATOR_NAME $GRAVITY_KEYRING_FLAG --output json | jq . >> $GRAVITY_HOME/validator_key.json
echo "Adding validator addresses to genesis files"
$GRAVITY $GRAVITY_HOME_FLAG add-genesis-account "$($GRAVITY $GRAVITY_HOME_FLAG keys show $GRAVITY_VALIDATOR_NAME -a $GRAVITY_KEYRING_FLAG)" $GRAVITY_GENESIS_COINS
echo "Generating orchestrator keys"
$GRAVITY $GRAVITY_HOME_FLAG keys add --dry-run=true --output=json $GRAVITY_ORCHESTRATOR_NAME | jq . >> $GRAVITY_HOME/orchestrator_key.json

echo "Adding orchestrator keys to genesis"
GRAVITY_ORCHESTRATOR_KEY="$(jq .address $GRAVITY_HOME/orchestrator_key.json)"

jq ".app_state.auth.accounts += [{\"@type\": \"/cosmos.auth.v1beta1.BaseAccount\",\"address\": $GRAVITY_ORCHESTRATOR_KEY,\"pub_key\": null,\"account_number\": \"0\",\"sequence\": \"0\"}]" $GRAVITY_HOME_CONFIG/genesis.json | sponge $GRAVITY_HOME_CONFIG/genesis.json
jq ".app_state.bank.balances += [{\"address\": $GRAVITY_ORCHESTRATOR_KEY,\"coins\": [{\"denom\": \"$NORMAL_DENOM\",\"amount\": \"100000000000\"},{\"denom\": \"$STAKE_DENOM\",\"amount\": \"100000000000\"}]}]" $GRAVITY_HOME_CONFIG/genesis.json | sponge $GRAVITY_HOME_CONFIG/genesis.json

echo "Creating gentxs"
$GRAVITY $GRAVITY_HOME_FLAG gentx --ip $GRAVITY_HOST $GRAVITY_VALIDATOR_NAME 100000000000$STAKE_DENOM "$ETH_ORCHESTRATOR_VALIDATOR_ADDRESS" "$(jq -r .address $GRAVITY_HOME/orchestrator_key.json)" $GRAVITY_KEYRING_FLAG $GRAVITY_CHAINID_FLAG

echo "Collecting gentxs in $GRAVITY_NODE_NAME"
$GRAVITY $GRAVITY_HOME_FLAG collect-gentxs

echo "Exposing ports and APIs of the $GRAVITY_NODE_NAME"
# Switch sed command in the case of linux
fsed() {
  if [ `uname` = 'Linux' ]; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

# Change ports
fsed "s#\"tcp://127.0.0.1:26656\"#\"tcp://$GRAVITY_HOST:26656\"#g" $GRAVITY_NODE_CONFIG
fsed "s#\"tcp://127.0.0.1:26657\"#\"tcp://$GRAVITY_HOST:26657\"#g" $GRAVITY_NODE_CONFIG
fsed 's#addr_book_strict = true#addr_book_strict = false#g' $GRAVITY_NODE_CONFIG
fsed 's#external_address = ""#external_address = "tcp://'$GRAVITY_HOST:26656'"#g' $GRAVITY_NODE_CONFIG
fsed 's#enable = false#enable = true#g' $GRAVITY_APP_CONFIG
fsed 's#swagger = false#swagger = true#g' $GRAVITY_APP_CONFIG
