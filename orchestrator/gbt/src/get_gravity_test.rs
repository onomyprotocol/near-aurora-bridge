use clarity::Address as EthAddress;
use ethereum_gravity::utils::get_gravity_id;
use std::{cmp::min, time::Duration};
use tokio::runtime::Runtime;
use web30::client::Web3;

#[test]
fn test_get_gravity_id() {
    let mut rt = tokio::runtime::Runtime::new().unwrap();
    let local = tokio::task::LocalSet::new();
    local.block_on(&mut rt, async move {
        // aurora testnet
        let url = "http://testnet.aurora.dev";
        let gravity_address_string = "0x1b6aFCdcf47781F1F996dDeC40E8883F41917Fb8";

        // rinkybe
        // let url = "http://eth-rinkeby.alchemyapi.io/v2/0iGN3oZ9y_CKTaelqOV1XfLnCCiKNRoR";
        // let gravity_address_string = "0x8A0814b7251138Dea19054425D0dfF0C497305d3";

        // address: 0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d
        // private key: c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709
        let caller_address_string = "0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d";

        let web3 = Web3::new(&url, Duration::from_secs(300));

        let block = web3.eth_block_number().await;
        if block.is_err() {
            error!("Failed to get latest block!, {:?}", block);
        }
        println!("eth_block_number {}", block.unwrap());

        let caller_address: EthAddress = caller_address_string
            .parse()
            .unwrap();

        let gravity_contract_address: EthAddress = gravity_address_string
            .parse()
            .unwrap();

        let gravity_id = get_gravity_id(gravity_contract_address, caller_address, &web3).await;
        if gravity_id.is_err() {
            error!("Failed to get gravity id!, {:?}", gravity_id);
        }
        println!("gravity_id {}", gravity_id.unwrap());
    });
}
