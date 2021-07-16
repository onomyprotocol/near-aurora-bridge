## single-node-runner-tester.yml
- Whenever a pull request is initiated to the main branch from this branch this gitAction will start a testnet in a remote machine using ```shivachaudhary10/single-node-runner:v-1``` this image.
- Once this gitAction is successful you can access validator-set from addresses :-
 [http://192.241.143.199:26657/validators](http://192.241.143.199:26657/validators)
- Then all the integration tests take place.

## kill-container.yml
- Whenever the raised pull request is closed or merged this gitAction will get triggered and it kills the running container in the remote machine.

---
- ```shivachaudhary10/single-node-runner:v-1``` this image was build using the code from [dzmitryhil/single-node-runners](https://github.com/onomyprotocol/cosmos-gravity-bridge/tree/dzmitryhil/single-node-runners) branch