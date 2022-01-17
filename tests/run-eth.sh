#!/bin/bash
# Starts the Ethereum testnet chain in the background

echo "Copying aurora.node0.json"
# copy aurora key because it might be change after the container rebuild
id=$(docker create --rm onomy/aurora-engine-local:latest)
docker cp $id:/root/.near-credentials/local/aurora.node0.json aurora/aurora.node0.json \
  & docker rm -f $id

echo "Starting the aurora chain"
docker-compose --profile aurora up -d

echo "Waiting for 3030 port to come online"
while ! nc -z localhost 3030; do
  sleep 2
done

echo "Init aurora account"
docker-compose exec -T near /bin/bash /root/assets/aurora/fund_aurora_account.sh