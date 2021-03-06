\#!/bin/bash
set -eux
# the directory of this script, useful for allowing this script
# to be run with any PWD
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# builds the container containing various system deps
# also builds Gravity once in order to cache Go deps, this container
# must be rebuilt every time you run this test if you want a faster
# solution use start chains and then run tests
# note, this container does not need to be rebuilt to test the same code
# twice, docker will automatically detect and cache this case, no need
# for that logic here
bash $DIR/build-container.sh

# Remove existing container instance
set +e
docker rm -f nab_all_up_test_instance
set -e

NODES=3
set +u
TEST_TYPE=$1
ALCHEMY_ID=$2
set -u

echo "Clearing containers"
docker-compose down

bash $DIR/run-eth.sh

echo "Starting test"
docker-compose run nab /bin/bash /nab/tests/container-scripts/all-up-test-internal.sh $NODES $TEST_TYPE $ALCHEMY_ID

echo "Clearing containers"
docker-compose down
