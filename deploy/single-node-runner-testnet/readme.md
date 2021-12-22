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

The "single-node-runner-testnet" is a docker image that contains already prebuilt nab home files, and a
constant Gravity.sol contract address deployed to the Rinkeby. The container runs the nab test net with one validator
and one bridge orchestrator. This is a minimum that makes the bridge works.

## Entrypoints 

0.0.0.0 should be change to a host of a deployed container

- nab swagger: [http://0.0.0.0:1317/swagger/](http://0.0.0.0:1317/swagger/)
- nab rpc: [http://0.0.0.0:1317/](http://0.0.0.0:1317/)
- nab grpc: [http://0.0.0.0:9090/](http://0.0.0.0:9090/)
- ethereum rpc: [http://0.0.0.0:8545/](http://0.0.0.0:8545/) | [geth API docs](https://geth.ethereum.org/docs/rpc/server)

## Build

### Build locally
  
  ```
  docker build -t onomy/near-aurora-bridge-single-node-runner-testnet:local  -f Dockerfile ../../
  ```

## Run

  ```
  docker run --name near-aurora-bridge-single-node-runner-testnet \
              -p 26656:26656 -p 26657:26657 -p 1317:1317 -p 61278:61278 -p 9090:9090 -p 8545:8545 \
              -it --restart on-failure onomy/near-aurora-bridge-single-node-runner-testnet:latest
  ```

## Accounts

### Ethereum aurora testnet accounts

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

### Cosmos/nab test chain accounts

- orchestrator

```
"name": "orch",
"type": "local",
"address": "cosmos1s99d5skpemcg2jzq6exsrj30q7j5rhkghf09qw",
"pubkey": "cosmospub1addwnpepq2c9rxne70utj93k8n2k03gze76qhhxp0jwjwesfg4kdy83y7vmg6tvu2ny",
"mnemonic": "loop famous say place sign purchase sadness escape bean dream load keen hazard ivory step tide mandate purpose produce head empty scene display convince"
```

- validator
```

"name": "val",
"type": "local",
"address": "cosmos173yvj5tf970308kkpw87ya4heny6psxafq03sr",
"pubkey": "cosmospub1addwnpepqftp79583v6gdenulw5yjrqqu0l3dqaqp44uj0ykwag09rj59ev3yr6kn45",
"mnemonic": "vast almost payment betray solve badge street install certain resemble sausage gossip supreme spoil wait rough finish bike song enhance clown front absent border"

```

## Client

The ETC20 coins used in that part are FAU. You can substitute "erc20-address" to any other token.

  ### Inside the single-runner-container (all tools already installed)
  
  - Connect to the container and go to orchestrator/client folder
    
    ```
    docker exec -it near-aurora-bridge-single-node-runner-testnet bash
    ```
    

  - Mint some tokens for 0xDa331E76dAf3a008b96f66bf8175458CD8a9e9E7 bath accounts 

  - Get cosmos user's balance:
    ```
    nab query bank balances cosmos173yvj5tf970308kkpw87ya4heny6psxafq03sr --chain-id nab
    ```
  
  - Send from eth to cosmos (from 0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0 to cosmos173yvj5tf970308kkpw87ya4heny6psxafq03sr)
    ```
    gbt client eth-to-cosmos \
            --ethereum-key="c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709" \
            --ethereum-rpc="http://testnet.aurora.dev" \
            --gravity-contract-address=0x32EB0AbB474CFb880B14ac62082daf938d5D37Dd \
            --token-contract-address=0xDa331E76dAf3a008b96f66bf8175458CD8a9e9E7 \
            --amount=7 \
            --destination=cosmos173yvj5tf970308kkpw87ya4heny6psxafq03sr
    ```
  
  - Now check users balances on both sides
  
  - Send from cosmos to eth (from cosmos173yvj5tf970308kkpw87ya4heny6psxafq03sr to 0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d /different eth address)
  
    ```
    gbt client cosmos-to-eth --cosmos-phrase="vast almost payment betray solve badge street install certain resemble sausage gossip supreme spoil wait rough finish bike song enhance clown front absent border" \
                    --cosmos-grpc="http://0.0.0.0:9090" \
                    --fees=10nab0xDa331E76dAf3a008b96f66bf8175458CD8a9e9E7 \
                    --amount=1000000000000000000nab0xDa331E76dAf3a008b96f66bf8175458CD8a9e9E7 \
                    --eth-destination=0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d
    
  - Now check users balances on both sides one more time
