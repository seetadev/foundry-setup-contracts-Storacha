// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/PPTToken.sol";

contract DeployPPTToken is Script {
    function run() external {
        address deployer = msg.sender;

        vm.startBroadcast();

        PPTToken token = new PPTToken();

        vm.stopBroadcast();

        console.log("PPTToken deployed at:", address(token));
        console.log("Total supply (whole tokens):", token.TOTAL_SUPPLY() / 1e18);
        console.log("Deployer balance (whole tokens):", token.balanceOf(deployer) / 1e18);
    }
}
