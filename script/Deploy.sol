pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

import {Capsule} from "../src/Capsule.sol";
import {UpgradeableProxy} from "../src/UpgradeableProxy.sol";

contract TaskTest is Script {
    address public deployer;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        deployer = vm.createWallet(deployerPrivateKey).addr;
        vm.startBroadcast(deployerPrivateKey);

        deploy();

        vm.stopBroadcast();
    }

    function deploy() public {
        // deploy contracts
        Capsule capsule = new Capsule(
            1745528400,
            "https://nft.goat.network/assets/848b19b3b6a0c172b5b067f818f76b93992d62aaf15c848dac03eb3e1fcbc95f.json"
        );
        UpgradeableProxy proxy = new UpgradeableProxy(
            address(capsule),
            deployer,
            ""
        );
        capsule = Capsule(payable(proxy));
        capsule.initialize("OnePiece Capsule", "OC");

        console.log("capsule contract address: ", address(capsule));
    }
}
