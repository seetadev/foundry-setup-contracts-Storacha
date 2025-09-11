// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PPTToken.sol";

contract PPTTokenTest is Test {
    PPTToken token;

    function setUp() public {
        token = new PPTToken(1000);
    }

    function testInitialSupply() public  view{
        // totalSupply should be 1000 * 10^18
        assertEq(token.totalSupply(), 1000 * 10**18);
    }

    function testBalanceOfDeployer() public view{
        // Deployer should have initial supply balance
        assertEq(token.balanceOf(address(this)), 1000 * 10**18);
    }

    function testTransfer() public {
        address recipient = address(0x123);
        uint256 amount = 10 * 10**18;

        token.transfer(recipient, amount);
        assertEq(token.balanceOf(recipient), amount);
    }
}
