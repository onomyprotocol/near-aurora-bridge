## Build locally

```
docker build -t onomy/near-aurora-local:local-bridge --progress=plain  -f Dockerfile .
```

## Run locally

```
docker run -p 3030:3030 --name onomy-near-local-bridge onomy/near-aurora-local:local-bridge
```

## Steps to test the bridge ETH -> near and near -> ETH

* Connect to the container:
```
docker exec -it near-aurora-local-bridge bash
```

* Let's check the balance of `node0` account.

```bash
cli/index.js TESTING get-bridge-on-near-balance --near-receiver-account node0
```

* Transfer some from ETH to near. The operation mite take few minutes.

```bash
cli/index.js TESTING transfer-eth-erc20-to-near --amount 1000 --eth-sender-sk 0x2bdd21761a483f71054e14f5b827213567971c676928d9a1808cbfa4b7501200 --near-receiver-account node0 --near-master-account neartokenfactory
```

Now you check the balance of `node0` again. You should notice the balance was changed.

Notice: `neartokenfactory` account here to pay for the NEAR gas fees, any account for which we know a secret key would've worked too.
You must observe blocks being submitted.

* Check the ERC20 balance of the receiver before and after receiving the transfer back from the NEAR side

```bash
cli/index.js TESTING get-erc20-balance 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8
```

* Transfer one token back to Ethereum

```bash
cli/index.js TESTING transfer-eth-erc20-from-near --amount 10 --near-sender-account node0 --near-sender-sk ed25519:3D4YudUQRE39Lc4JHghuB5WM8kbgDDa34mnrEP5DdTApVH81af7e2dWgNPEaiQfdJnZq1CNPp5im4Rg5b733oiMP --eth-receiver-address 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8
```

You should observe the change of the ERC20 balance as reported by the CLI.
