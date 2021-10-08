import {Gravity} from "./typechain/Gravity";
import {ethers} from "ethers";
import fs from "fs";

async function deploy() {
  // aurora testnet
  // const eth_url = "http://testnet.aurora.dev";

  // rinkybe
  const eth_url = "http://eth-rinkeby.alchemyapi.io/v2/0iGN3oZ9y_CKTaelqOV1XfLnCCiKNRoR";

  const eth_private_key = "c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709"

  const provider = await new ethers.providers.JsonRpcProvider(eth_url);
  let wallet = new ethers.Wallet(eth_private_key, provider);

  console.log("Starting Gravity contract deploy");
  const {abi, bytecode} = getContractArtifacts("Gravity.json");
  const factory = new ethers.ContractFactory(abi, bytecode, wallet);

  const gravityId = ethers.utils.formatBytes32String("defaultgravityid");

  const vote_power = 2834678415;

  let eth_addresses = [];
  eth_addresses.push("0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d");

  let powers = [];
  powers.push(4294967295);

  const overrides = {
    //gasPrice: 100000000000
  }

  const gravity = (await factory.deploy(gravityId, vote_power, eth_addresses, powers, overrides)) as Gravity;

  await gravity.deployed();
  console.log("Gravity deployed at Address - ", gravity.address);

  let logInfo = {
    address: gravity.address,
    topics: [],
    fromBlock: "earliest",
    toBlock: "latest",
  }
  provider.getLogs(logInfo).then((res) => console.log(res))

  // ValsetUpdatedEvent(uint256,uint256,uint256,address,address[],uint256[]) - "0x76d08978c024a4bf8cbb30c67fd78fcaa1827cbc533e4e175f36d07e64ccf96a";

}

function getContractArtifacts(path: string): { bytecode: string; abi: string } {
  var {bytecode, abi} = JSON.parse(fs.readFileSync(path, "utf8").toString());
  return {bytecode, abi};
}

async function main() {
  await deploy();
}

main();
