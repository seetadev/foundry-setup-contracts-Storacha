// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/FlowSendToken.sol";

contract DeployToken is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy FlowSendToken with initial supply (in whole tokens)
        // Example: 1,000,000 tokens
        FlowSendToken token = new FlowSendToken(1_000_000);

        vm.stopBroadcast();

        console.log("FlowSendToken deployed at:", address(token));
    }
}
