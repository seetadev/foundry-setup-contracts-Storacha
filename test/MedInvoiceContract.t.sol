// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MedInvoiceContract.sol";
import "../src/PPTToken.sol";

contract MedInvoiceContractTest is Test {
    PPTToken token;
    MedInvoiceContract contractInstance;

    address user = address(0xBEEF);

    function setUp() public {
        token = new PPTToken(1000);
        contractInstance = new MedInvoiceContract(address(token));

        // Give the user some PPT tokens
        token.transfer(user, 50 * 10 ** 18);

        // Fund the MedInvoiceContract with tokens it can send during subscribe
        token.transfer(address(contractInstance), 100 * 10 ** 18);
    }

    function testSubscribe() public {
        vm.prank(user);
        token.approve(address(contractInstance), type(uint256).max);

        contractInstance.subscribe();

        (bool exists, uint256 endTime) = contractInstance
            .getSubscriptionDetails();
        assertTrue(exists);
        assertGt(endTime, block.timestamp);

        vm.stopPrank();
    }

    function testSaveAndRetrieveFile() public {
        vm.prank(user);
        vm.assume(token.balanceOf(user) >= 1);

        vm.prank(user);
        contractInstance.saveFile("Demo file content");

        vm.prank(user);
        string[] memory files = contractInstance.getFiles();

        assertEq(files.length, 1);
        assertEq(files[0], "Demo file content");
        vm.stopPrank();
    }

    function testCannotSaveFileIfNoToken() public {
        address poorUser = address(0xAAA);
        vm.prank(poorUser);
        vm.expectRevert("You need to hold a MediToken to save.");
        contractInstance.saveFile("Should fail");
        vm.stopPrank();
    }
}
