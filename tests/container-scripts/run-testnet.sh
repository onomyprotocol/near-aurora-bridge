#!/bin/bash
set -eux
# your gaiad binary name
BIN=nab

NODES=$1
set +u
TEST_TYPE=$2
ALCHEMY_ID=$3
set -u

for i in $(seq 1 $NODES);
do
    # add this ip for loopback dialing
    ip addr add 7.7.7.$i/32 dev eth0 || true # allowed to fail

    GAIA_HOME="--home /validator$i"
    # this implicitly caps us at ~6000 nodes for this sim
    # note that we start on 26656 the idea here is that the first
    # node (node 1) is at the expected contact address from the gentx
    # faciliating automated peer exchange
    if [[ "$i" -eq 1 ]]; then
        # node one gets localhost so we can easily shunt these ports
        # to the docker host
        RPC_ADDRESS="--rpc.laddr tcp://0.0.0.0:26657"
        GRPC_ADDRESS="--grpc.address 0.0.0.0:9090"
    else
        # move these to another port and address, not becuase they will
        # be used there, but instead to prevent them from causing problems
        # you also can't duplicate the port selection against localhost
        # for reasons that are not clear to me right now.
        RPC_ADDRESS="--rpc.laddr tcp://7.7.7.$i:26658"
        GRPC_ADDRESS="--grpc.address 7.7.7.$i:9091"
    fi
    LISTEN_ADDRESS="--address tcp://7.7.7.$i:26655"
    P2P_ADDRESS="--p2p.laddr tcp://7.7.7.$i:26656"
    LOG_LEVEL="--log_level info"
    ARGS="$GAIA_HOME $LISTEN_ADDRESS $RPC_ADDRESS $GRPC_ADDRESS $LOG_LEVEL $P2P_ADDRESS"
    $BIN $ARGS start &> /validator$i/logs &
done

# let the cosmos chain settle before starting eth as it
# consumes a lot of processing power
sleep 10

# Aurora and TEST_TYPE may be unbound
set +u

# Starts a hardhat RPC backend that is based off of a fork of Ethereum mainnet. This is useful in that we take
# over the account of a major Uniswap liquidity provider and from there we can test many things that are infeasible
# to do with a Aurora backend, simply becuase reproducting that state on our testnet would be far too complex to consider
# The tradeoff here is that hardhat is an ETH dev environment and not an actual ETH implementation, as such the outputs
# may be different. These two tests have different fork block heights they rely on
if [[ $TEST_TYPE == *"ARBITRARY_LOGIC"* ]]; then
    export ALCHEMY_ID=$ALCHEMY_ID
    pushd /nab/solidity
    npm run solidity_test_fork &
    popd
elif [[ $TEST_TYPE == *"RELAY_MARKET"* ]]; then
    export ALCHEMY_ID=$ALCHEMY_ID
    pushd /nab/solidity
    npm run evm_fork &
    popd
# This starts a hardhat test environment with no pre-seeded state, faster to run, not accurate
elif [[ ! -z "$HARDHAT" ]]; then
    pushd /nab/solidity
    npm run evm &
    popd
fi