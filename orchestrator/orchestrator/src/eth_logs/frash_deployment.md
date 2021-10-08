# Aurora initial contract:

```
npx ts-node \                                                                                  
contract-deployer.ts \
--cosmos-node="http://0.0.0.0:26657" \
--eth-node="http://testnet.aurora.dev/" \
--eth-privkey="c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709" \
--contract=Gravity.json \
--test-mode=false
```

```
Starting Gravity contract deploy
About to get latest Gravity valset
{
  "type": "nab/Valset",
  "value": {
    "nonce": "2",
    "members": [
      {
        "power": "4294967295",
        "ethereum_address": "0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d"
      }
    ],
    "height": "4363",
    "reward_amount": "0",
    "reward_token": "0x0000000000000000000000000000000000000000"
  }
}
Gravity deployed at Address -  0x5ee587E10F66C45cE2d19253761E3Ab0358260a2
```

Logs after deployment

```
{
  "jsonrpc": "2.0",
  "id": 0,
  "method": "eth_getLogs",
  "params": [
    {
      "fromBlock": "earliest",
      "toBlock": "latest",
      "address": "0x5ee587E10F66C45cE2d19253761E3Ab0358260a2",
      "topics": []
    }
  ]
}
```

```
{
    "jsonrpc": "2.0",
    "id": 0,
    "result": []
}
```


# Rinkeby initial contract:

```
npx ts-node \
contract-deployer.ts \
--cosmos-node="http://0.0.0.0:26657" \
--eth-node="http://eth-rinkeby.alchemyapi.io/v2/0iGN3oZ9y_CKTaelqOV1XfLnCCiKNRoR" \
--eth-privkey="c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709" \
--contract=Gravity.json \
--test-mode=false
```

```
Starting Gravity contract deploy

About to get latest Gravity valset
{
  "type": "nab/Valset",
  "value": {
    "nonce": "2",
    "members": [
      {
        "power": "4294967295",
        "ethereum_address": "0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d"
      }
    ],
    "height": "4384",
    "reward_amount": "0",
    "reward_token": "0x0000000000000000000000000000000000000000"
  }
}
Gravity deployed at Address -  0xEB152bA7044dBdAc8b5578dc0e3728fC296574e3
```


```
Logs after deployment

{
  "jsonrpc": "2.0",
  "id": 0,
  "method": "eth_getLogs",
  "params": [
    {
      "fromBlock": "earliest",
      "toBlock": "latest",
      "address": "0xEB152bA7044dBdAc8b5578dc0e3728fC296574e3",
      "topics": []
    }
  ]
}
```

```
{
    "id": 0,
    "jsonrpc": "2.0",
    "result": [
        {
            "address": "0xeb152ba7044dbdac8b5578dc0e3728fc296574e3",
            // ValsetUpdatedEvent
            "topics": [
                "0x76d08978c024a4bf8cbb30c67fd78fcaa1827cbc533e4e175f36d07e64ccf96a",
                "0x0000000000000000000000000000000000000000000000000000000000000000"
            ],
            "data": "0x00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000010000000000000000000000002d9480eba3a001033a0b8c3df26039fd3433d55d000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000ffffffff",
            "blockNumber": "0x8fdd45",
            "transactionHash": "0x8e0a5a65c10c36f248bd1d534e427eef3c0448057898027971f1bc850057ab33",
            "transactionIndex": "0x6",
            "blockHash": "0xdc21173e749eba8c4456bf03d35689c75c75105139b3d8321539f4f8dab22f28",
            "logIndex": "0x8",
            "removed": false
        }
    ]
}
```