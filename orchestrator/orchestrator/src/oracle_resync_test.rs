use clarity::Address as EthAddress;
use ethereum_gravity::utils::get_gravity_id;
use std::{cmp::min, time::Duration};
use tokio::runtime::Runtime;
use web30::client::Web3;
use gravity_proto::gravity::query_client::QueryClient as GravityQueryClient;
use crate::{oracle_resync::get_last_checked_block};
use deep_space::address::Address as CosmosAddress;

#[test]
fn test_get_last_checked_block() {
    let mut rt = tokio::runtime::Runtime::new().unwrap();
    let local = tokio::task::LocalSet::new();
    local.block_on(&mut rt, async move {

        let cosmos_url = "http://0.0.0.0:9090";
        let cosmos_client = GravityQueryClient::connect(cosmos_url).await.unwrap();

        let cosmos_address_string = "cosmos1s99d5skpemcg2jzq6exsrj30q7j5rhkghf09qw";
        let cosmos_address: CosmosAddress = cosmos_address_string.parse().unwrap();

        let cosmos_prefix = "cosmos".parse().unwrap();

        // aurora testnet
        // let eth_url = "http://testnet.aurora.dev";
        // let gravity_address_string = "0xed6929f32C01646AE9BB25757BE521bA8Ce2512e";

        // rinkybe
        // let eth_url = "http://eth-rinkeby.alchemyapi.io/v2/0iGN3oZ9y_CKTaelqOV1XfLnCCiKNRoR";
        // let gravity_address_string = "0x8A0814b7251138Dea19054425D0dfF0C497305d3";

        let gravity_contract_address: EthAddress = gravity_address_string.parse().unwrap();

        let web3 = Web3::new(&eth_url, Duration::from_secs(300));

        get_last_checked_block(
            cosmos_client,
            cosmos_address,
            cosmos_prefix,
            gravity_contract_address,
            &web3,
        ).await;
    });
}
