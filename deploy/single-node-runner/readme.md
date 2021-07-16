# Single node runner
## Description
The single-node-runner is a comprehensive gravity-module network container with one validator.
## Build and run details
The docker image builds required artifacts (gravity, solidity contract, orchestrator),
generates cosmos/gravity validators for gravity module and ethereum network for each build,
thus each version of the image consists of a unique test-net.
On the docker CMD step docker bootstraps, all the components prepared on the build step.

### How to run

#### Using docker 
```
docker run --name cosmos-gravity-bridge-single-node-runner -p 26656:26656 -p 26657:26657 -p 1317:1317 -p 61278:61278 -p 9090:9090 -p 8545:8545 -it --restart on-failure onomy/cosmos-gravity-bridge-single-node-runner:v-5
```

**v-5** here is a tag of the runner. You can get the full list on the page [tags](https://hub.docker.com/repository/docker/onomy/cosmos-gravity-bridge-single-node-runner/tags?page=1&ordering=last_updated)

Pay attention that once you change the version of the image the test net within the container is different,
hence the validator key, contact addresses and etc. will be different as well.

#### Using docker-compose

```
docker-compose up
```

#### Troubleshooting
In some cases the container might fail because of lack of timeout, in case you need to start it one more time by calling
```
docker start -it cosmos-gravity-bridge-single-node-runner
```

#### Remove the container
```
docker rm -f cosmos-gravity-bridge-single-node-runner
```

### How to build locally
Run the command inside the single-node-runner folder
```
docker build -t onomy/cosmos-gravity-bridge-single-node-runner:local  -f Dockerfile ../../
```
The result image will be `onomy/cosmos-gravity-bridge-single-node-runner:local`

### Useful commands

#### Print the orchestrator_key
```
docker exec -i cosmos-gravity-bridge-single-node-runner cat /root/home/testchain/gravity/orchestrator_key.json
```

#### Print the validator_key
```
docker exec -i cosmos-gravity-bridge-single-node-runner cat /root/home/testchain/gravity/validator_key.json
```

#### Print the eth_key
```
docker exec -i cosmos-gravity-bridge-single-node-runner cat /root/home/testchain/gravity/eth_key.json
```

#### Print the eth_contract_address
```
docker exec -i cosmos-gravity-bridge-single-node-runner cat /root/home/testchain/gravity/eth_contract_address
```

#### Connect to container 
```
docker exec -it cosmos-gravity-bridge-single-node-runner sh 

```

### Entrypoints
- gravity swagger: [http://0.0.0.0:1317/swagger/](http://0.0.0.0:1317/swagger/)
- gravity rpc: [http://0.0.0.0:1317/](http://0.0.0.0:1317/)
- gravity grpc: [http://0.0.0.0:9090/](http://0.0.0.0:9090/)
- ethereum rpc: [http://0.0.0.0:8545/](http://0.0.0.0:8545/) | [geth API docs](https://geth.ethereum.org/docs/rpc/server)
