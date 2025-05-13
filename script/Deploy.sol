pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

import {Capsule} from "../src/Capsule.sol";
import {UniProxy} from "../src/UniProxy.sol";

contract TaskTest is Script {
    address public deployer;
    address public admin;
    address public proxyAdminContract;

    function run() public {
        admin = vm.envAddress("ADMIN_ADDR");
        proxyAdminContract = vm.envAddress("PROXY_ADMIN_CONTRACT");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        deployer = vm.createWallet(deployerPrivateKey).addr;
        vm.startBroadcast(deployerPrivateKey);

        deploy();
        // deployLogic();

        vm.stopBroadcast();
    }

    function deploy() public {
        // deploy contracts
        Capsule capsule = new Capsule();
        UniProxy proxy = new UniProxy(address(capsule), proxyAdminContract, "");
        capsule = Capsule(payable(proxy));
        capsule.initialize(
            admin,
            1746741600,
            "Test NFT",
            "TEST",
            "https://nft.goat.network/assets/848b19b3b6a0c172b5b067f818f76b93992d62aaf15c848dac03eb3e1fcbc95f.json"
        );
        console.log("capsule contract address: ", address(capsule));
    }

    function deployLogic() public {
        // deploy contracts
        Capsule capsule = new Capsule();
        console.log("capsule contract address: ", address(capsule));
    }
}
