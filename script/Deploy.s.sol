// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/PPTToken.sol";
import "../src/MedInvoiceContract.sol";

contract DeployContract is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy PPTToken with an initial supply (change as needed)
        PPTToken token = new PPTToken(20000);

        // Deploy MedInvoiceContract with PPTToken address
        MedInvoiceContract medInvoice = new MedInvoiceContract(address(token));

        vm.stopBroadcast();

        console.log("PPTToken deployed at:", address(token));
        console.log("MedInvoiceContract deployed at:", address(medInvoice));
    }
}
