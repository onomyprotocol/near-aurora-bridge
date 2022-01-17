* Copy the latest key from the near images
```
docker-compose pull

id=$(docker create --rm onomy/aurora-engine-local:latest)
docker cp $id:/root/.near-credentials/local/aurora.node0.json config/aurora.node0.json \
& docker rm -f $id

```

* Run
```
docker-compose down && docker-compose up -d
```

* Login to container
```
docker exec -it near-aurora-local sh
```

* Fund account
```
export NEAR_ENV=local
export AURORA_ENGINE=aurora.node0
export NEAR_MASTER_ACCOUNT=aurora.node0

near call aurora.node0 fund_account '{"address": "0xBf660843528035a5A4921534E156a27e64B231fE", "amount": "100000000000000000000000"}' \
    --accountId aurora.node0 --keyPath /root/.near-credentials/local/aurora.node0.json

aurora get-balance 0xBf660843528035a5A4921534E156a27e64B231fE
aurora get-nonce 0xBf660843528035a5A4921534E156a27e64B231fE
```

* Get balance form the web3 (the assumption that you are inside the prev step in the container)

```
curl -X POST \
  http://endpoint:8545/ \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: 904210f6-ba28-e4de-59d1-a8f2559ddc5b' \
  -d '{
	"jsonrpc":"2.0", 
	"method":"eth_getBalance", 
	"params":["0xBf660843528035a5A4921534E156a27e64B231fE", "latest"], 
	"id":1
}'
```