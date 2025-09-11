// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/PPTToken.sol";
import "../src/MedInvoiceContract.sol";

contract DeployAndVerifyContract is Script {
    function run() external {
        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy PPTToken with initial supply of 1,000 tokens
        PPTToken token = new PPTToken(1000);

        // Deploy MedInvoiceContract with address of the deployed PPTToken
        MedInvoiceContract medInvoice = new MedInvoiceContract(address(token));

        // Stop broadcast
        vm.stopBroadcast();

        // Log deployed addresses
        console.log("PPTToken deployed at:", address(token));
        console.log("MedInvoiceContract deployed at:", address(medInvoice));
    }
}
