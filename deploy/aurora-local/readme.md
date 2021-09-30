## Build locally

```
docker build -t onomy/near-aurora-local:local --progress=plain  -f Dockerfile .
```

## Run locally

```
docker run -p 3030:3030 --name onomy-near-local onomy/near-aurora-local:local
```

## Create a new near account

```
export NEAR_ENV=local && near create-account aurora.node0 --master-account=node0 --initial-balance 100000 --keyPath ~/.near/localnet/node0/validator_key.json
```

## Create a new near account

```
export NEAR_ENV=local

near deploy --account-id=aurora.node0 --wasm-file=/assets/mainnet-release.wasm --keyPath ~/.near/localnet/node0/validator_key.json

aurora -d -v initialize --chain 1313161556 --engine aurora.node0 --owner node0 --signer aurora.node0
```

now inspect the node

```
aurora get-version --engine aurora.node0
aurora get-owner --engine aurora.node0
aurora get-chain-id --engine aurora.node0
```