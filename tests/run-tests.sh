#!/bin/bash
TEST_TYPE=$1
set -eu

set +u
OPTIONAL_KEY=""
if [ ! -z $2 ];
    then OPTIONAL_KEY="$2"
fi
set -u

echo "Clearing containers"
docker-compose down

bash $DIR/run-eth.sh

echo "Starting test"
docker-compose run nab /bin/bash /nab/tests/container-scripts/all-up-test-internal.sh 3 $TEST_TYPE $OPTIONAL_KEY

echo "Clearing containers"
docker-compose down