# Single node runner rinkeby

Table of Contents
=================
*  [Description](#Description)
*  [Entrypoints](#Entrypoints)
*  [Build](#Build)
*  [Run](#Run)
*  [Accounts](#Accounts)
*  [Client](#Client)
*  [Tools](#Tools)

## Description

The "single-node-runner-rinkeby" is a docker image that contains already prebuilt gravity home files, and a
constant Gravity.sol contract address deployed to the Rinkeby. The container runs the gravity test net with one validator
and one bridge orchestrator. This is a minimum that makes the bridge works.

## Entrypoints 

0.0.0.0 should be change to a host of a deployed container

- gravity swagger: [http://0.0.0.0:1317/swagger/](http://0.0.0.0:1317/swagger/)
- gravity rpc: [http://0.0.0.0:1317/](http://0.0.0.0:1317/)
- gravity grpc: [http://0.0.0.0:9090/](http://0.0.0.0:9090/)
- ethereum rpc: [http://0.0.0.0:8545/](http://0.0.0.0:8545/) | [geth API docs](https://geth.ethereum.org/docs/rpc/server)

## Build

### Build locally
  
  ```
  docker build -t onomy/cosmos-gravity-bridge-single-node-runner-rinkeby:local  -f Dockerfile ../../
  ```

### Steps to rebuild image from scratch

- Prepare gravity (generate genesys and etc.)

Run init-gravity.sh inside the container with binaries and copy $GRAVITY_HOME folder outside.
This home contains testnet chain settings and genesys file of the chain.

- Deploy Ethereum contact

    - edit contract-deployer.ts (add gasPrice and gasLimit, required for Rinkeby).
      ```
      // sets the gas price for all contract deployments
        const overrides = {
          gasPrice: 100000000000,
          gasLimit: 9000000
        }
      
        const gravity = (await factory.deploy(
          // todo generate this randomly at deployment time that way we can avoid
          // anything but intentional conflicts
          gravityId,
          vote_power,
          eth_addresses,
          powers,
          overrides
        )) as Gravity;
      ```
    - run deploy-contract.sh inside the container with binaries to deploy contract to the ethereum, save contract address for the further usage

    - or deploy manually

    ```
    cd /go/src/github.com/onomyprotocol/cosmos-gravity-bridge/solidity
    
    npx ts-node \
    contract-deployer.ts \
    --cosmos-node="http://0.0.0.0:26657" \
    --eth-node="http://0.0.0.0:8545" \
    --eth-privkey="e0b21b1d80e53f38734a3ed395796956b50c637916ddbb6cedb096b848053d2d" \
    --contract=artifacts/contracts/Gravity.sol/Gravity.json \
    --test-mode=false
    ```

***The contract used for the runner***.

```
Gravity deployed at Address - 0x8497452388c710Ebecd09adBF018C41f1Fe69876
```

## Run

- Run with docker (image from the dockerhub)

  ```
  docker run --name cosmos-gravity-bridge-single-node-runner-rinkeby \
              -p 26656:26656 -p 26657:26657 -p 1317:1317 -p 61278:61278 -p 9090:9090 -p 8545:8545 \
              -v /mnt/volume_nyc1_02:/root/home/testchain/gravity/data/. \
              -it --restart on-failure onomy/cosmos-gravity-bridge-single-node-runner-rinkeby:latest
  ```

  **latest** here is a tag of the runner. You can get the full list on the page [tags](https://hub.docker.com/repository/docker/onomy/cosmos-gravity-bridge-single-node-runner-rinkeby/tags?page=1&ordering=last_updated)
  
  The docker command uses local "/mnt/volume_nyc1_02" directory to save gravity db files, gravity_home/data/priv_validator_state.json 
  file should be there before the first run of container. 
  
  Eth Rinkeby data files are inside the container and will be re-synchronised is case of the container replacement 
  (and restored from the Rinkeby network).
  
- Run with docker compose
  ```
  docker-compose down && docker-compose up
  ```
  This docker-compose uses local image for the run.

## Accounts

### Ethereum rinkeby accounts

- root validator (contract deployer)
```
name: test-chain-root
address: 0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0
private key: e0b21b1d80e53f38734a3ed395796956b50c637916ddbb6cedb096b848053d2d
```

- orchestrator/validator
```
name: test-chain-orchestrator-validator:  
address: 0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d
private key: c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709
```

### Cosmos/gravity test chain accounts

- orchestrator
```
name: orch
address: cosmos107sxxhky509uk3qhjth9rehxrqzwnr08am7rh4,
pubkey: cosmospub1addwnpepqwcz42n8j6aqvfyaxr5693c8w72mem3td72rapvm9czxud9rvcldzfxsk7t,
mnemonic: warrior away frost estate roof express afford since sock hundred dinner laptop slice desert gas tackle chest during injury rebel morning venture layer plunge
```

- validator
```
name: val,
address: cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk,
pubkey: cosmospub1addwnpepq2l0x2yan9r3gn33wlvvhh7smw7lmq346k7tn2vq2k73cx4vgytm2chlpm2,
mnemonic: practice begin salad antenna curious margin muscle unfair typical pony acquire warm beyond seven cargo empower point hurt measure love critic pulse board attract
```

## Client

The ETC20 coins used in that part are FAU. You can substitute "erc20-address" to any other token.

  ### Inside the single-runner-container (all tools already installed)
  
  - Connect to the container and go to orchestrator/client folder
    
    ```
    docker exec -it cosmos-gravity-bridge-single-node-runner-rinkeby bash
    ```
    
    ```
    cd /go/src/github.com/onomyprotocol/cosmos-gravity-bridge/orchestrator/target/x86_64-unknown-linux-musl/release
    ```
  
  - Mint some FAU tokens for the 0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0 on the [page](https://erc20faucet.com/)

  - Get cosmos user's balance:
    ```
    gravity query bank balances cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk --chain-id test-chain
    ```
  
  - Send from eth to cosmos (from 0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0 to cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk)
    ```
    ./gbt client eth-to-cosmos \
            --ethereum-key="e0b21b1d80e53f38734a3ed395796956b50c637916ddbb6cedb096b848053d2d" \
            --ethereum-rpc="http://0.0.0.0:8545" \
            --gravity-contract-address=0x8497452388c710Ebecd09adBF018C41f1Fe69876 \
            --token-contract-address=0xFab46E002BbF0b4509813474841E0716E6730136 \
            --amount=10 \
            --destination=cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk
    ```
  
  - Now check users balances on both sides
  
  - Send from cosmos to eth (from cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk to 0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d /different eth address)
  
    ```
    ./gbt client cosmos-to-eth --cosmos-phrase="practice begin salad antenna curious margin muscle unfair typical pony acquire warm beyond seven cargo empower point hurt measure love critic pulse board attract" \
                    --cosmos-grpc="http://0.0.0.0:9090" \
                    --fees=1samoleans \
                    --amount=1000gravity0xFab46E002BbF0b4509813474841E0716E6730136 \
                    --eth-destination=0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d
    
  - Now check users balances on both sides one more time

  ### Using linux or docker/linux

  - Configure your environment
  Run docker with ubuntu and connect to the container
  ```
  docker run --name cosmos-gravity-bridge-single-node-runner-rinkeby-client  -v `pwd`/client/linux:/root/home/client -w /root/home/client -it ubuntu 
  ```
  - Add permissions
  ``` 
  chmod 777 ./gbt
  ```
  - Install curl (optional if already installed)
  ```
  apt-get update && apt-get install curl -yq
  ```
  - Set Eth host and gravity host (if the hosts are different, then change them from 0.0.0.0 to your hosts)
  ```
  ETH_HOST=0.0.0.0 && GRAVITY_HOST=0.0.0.0
  ```
  - Mint some FAU tokens for the 0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0 on the [page](https://erc20faucet.com/)

  - Check balance of the cosmos user cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk on the gravity side
  ```
  curl -X GET "http://$GRAVITY_HOST:1317/cosmos/bank/v1beta1/balances/cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk" -H "accept: application/json"
  ```

  - Send from eth to cosmos (from 0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0 to cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk)
  ```
  ./gbt client eth-to-cosmos \
        --ethereum-key="e0b21b1d80e53f38734a3ed395796956b50c637916ddbb6cedb096b848053d2d" \
        --ethereum-rpc="http://$ETH_HOST:8545" \
        --gravity-contract-address=0x8497452388c710Ebecd09adBF018C41f1Fe69876 \
        --token-contract-address=0xFab46E002BbF0b4509813474841E0716E6730136 \
        --amount=10 \
        --destination=cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk
  ```
  
  - Check balance of the user cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk on the gravity side (should be +10 gravity0xFab46E002BbF0b4509813474841E0716E6730136)
  ```
  curl -X GET "http://$GRAVITY_HOST:1317/cosmos/bank/v1beta1/balances/cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk" -H "accept: application/json"
  ```

  - Send from cosmos to eth (from cosmos1zhnk8zzzevl92evyhsq6e6p7835g885dcaz0uk to 0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d /different eth address)
  ```
  ./gbt client cosmos-to-eth --cosmos-phrase="practice begin salad antenna curious margin muscle unfair typical pony acquire warm beyond seven cargo empower point hurt measure love critic pulse board attract" \
                    --cosmos-grpc="http://$GRAVITY_HOST:9090" \
                    --fees=1samoleans \
                    --amount=1000gravity0xFab46E002BbF0b4509813474841E0716E6730136 \
                    --eth-destination=0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d
  ```
  - Now check users balances on both sides (cosmos/eth) one more time

  - Termination (optional -for the docker only)
  ```
  exit
  ```
  - Restart and attach (optional - for the docker only) 
  ```
  docker start cosmos-gravity-bridge-single-node-runner-rinkeby-client -a
  ```

### Bridge client description

The current client written in rust and located in the folder "orchestrator/client". Supported commands:

- **eth-to-cosmos** - send tokens from ethereum to cosmos

  The command interacts with the deployed ETH contract. It checks ERC20 availability and amounts, gets transaction nonce, sets default fee (or takes form options param)
  and sends transaction with `sendToCosmos` call to the Ethereum node.

  All necessary code located in the files `orchestrator/client/src/main.rs` and `orchestrator/ethereum_gravity/src/send_to_cosmos.rs`

  **CLI description**

  ```
  eth-to-cosmos --ethereum-key=<key> --ethereum-rpc=<url> --cosmos-prefix=<prefix> --contract-address=<addr> --erc20-address=<addr> --amount=<amount> --cosmos-destination=<dest> [--times=<number>]
  ```

- **cosmos-to-eth** - send tokens from cosmos to ethereum

  The command interacts with the cosmos gravity module, deployed as a part of the cosmos based chain.
  It checks the denom representation on the cosmos side (/gravity/v1beta/cosmos_originated/denom_to_erc20 gpcs query) to be sure the ERC20 will be consumed on the ETH side,
  (if you called `eth-to-cosmos` command before, the denom is already registered, if didn't you need to do it manually, by calling  `deploy-erc20-representation` command),
  then sets the bridge fee, checks the needed amount on the garavity user balance and calls grpc method `gravity.v1.MsgSendToEth`.

  All necessary code located in the files `orchestrator/client/src/main.rs` and `orchestrator/src/cosmos_gravity/send.rs`

  **CLI description**

  ```
  cosmos-to-eth --cosmos-phrase=<key> --cosmos-grpc=<url> --cosmos-prefix=<prefix> --cosmos-denom=<denom> --amount=<amount> --eth-destination=<dest> [--no-batch] [--times=<number>]
  ```

- **deploy-erc20-representation** - register erc20 tokens in cosmos

  The command interacts with the cosmos gravity module, deployed as a part of the cosmos based chain. It register erc20 in the cosmos based (gravity)
  chain, for the further usage for the `eth-to-cosmos` command.

  **CLI description**

    ```
    deploy-erc20-representation --cosmos-grpc=<url> --cosmos-prefix=<prefix> --cosmos-denom=<denom> --ethereum-key=<key> --ethereum-rpc=<url> --contract-address=<addr> --erc20-name=<name> --erc20-symbol=<symbol> --erc20-decimals=<decimals>
    ```

## Tools

### GRPC samples

#### Cosmos/Gravity GRPC

**all cosmos proto files files:** https://github.com/cosmos/cosmos-sdk/tree/master/proto/cosmos

- Set up cosmos/gravity host (or any other)
```
GRAVITY_HOST=0.0.0.0
```

- Query balance for the user - cosmos107sxxhky509uk3qhjth9rehxrqzwnr08am7rh4
``` 
grpcurl -plaintext \
    -import-path ./proto/proto \
    -import-path ./proto/third_party/proto \
    -proto ./proto/third_party/proto/cosmos/bank/v1beta1/query.proto \
    -d '{"address":"cosmos107sxxhky509uk3qhjth9rehxrqzwnr08am7rh4"}' \
    $GRAVITY_HOST:9090 \
    cosmos.bank.v1beta1.Query/AllBalances
```

- Describe the bridge queries
``` 
grpcurl \
    -import-path ./proto/proto \
    -import-path ./proto/third_party/proto \
    -proto ./proto/proto/gravity/v1/query.proto \
    $GRAVITY_HOST:9090 \
    describe gravity.v1.Query
```

#### Eth RPC

- Set up eth host (or any other)
```
ETH_HOST=0.0.0.0
```

- Get user balance (wei)
```
curl -X POST http://$ETH_HOST:8545 \
    -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0", "latest"],"id":1}'
```
response
```
{"jsonrpc":"2.0","id":1,"result":"0xeeea99d2bec67000"}
```

- Get user 0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0 token balance (FAU)
```  
  curl -X POST http://$ETH_HOST:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_call","params":[{"to": "0xFab46E002BbF0b4509813474841E0716E6730136", "data":"0x70a0823100000000000000000000000097D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0"}, "latest"],"id":2}'
```
response
```
{"jsonrpc":"2.0","id":2,"result":"0x0000000000000000000000000000000000000000000000381b82a855c14c0000"}
```

### Geth tools

- Connect to the container
```
docker exec -it gravity-bridge-single-node-runner-rinkeby bash
```
- Attach console:
```
geth --rinkeby attach ipc:/root/.ethereum/rinkeby/geth.ipc console
```
- Get current status if syncing
```
eth.syncing
```
- Get num of peers
```
net.peerCount
```
- Show accounts
```
eth.accounts
```
- Get balance (test root account)
```
web3.eth.getBalance('0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0')
```
