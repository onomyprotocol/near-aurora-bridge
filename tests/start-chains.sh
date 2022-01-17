#!/bin/bash
TEST_TYPE=$1
ALCHEMY_ID=$2
set -eux

# the directory of this script, useful for allowing this script
# to be run with any PWD
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Remove existing container instance
set +e
docker rm -f nab_test_instance
set -e

NODES=3

bash $DIR/run-eth.sh

echo "Starting test"
docker run --name nab_test_instance --network testnet --mount type=bind,source="$(pwd)"/,target=/nab --cap-add=NET_ADMIN -p 9090:9090 -p 26657:26657 -p 1317:1317 -p 8545:8545 -it nab-base /bin/bash /nab/tests/container-scripts/reload-code.sh $NODES $TEST_TYPE $ALCHEMY_ID
