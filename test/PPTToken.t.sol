// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

import "forge-std/Test.sol";
import "../src/PPTToken.sol";

contract PPTTokenTest is Test {
    PPTToken token;

    function setUp() public {
        token = new PPTToken();
    }

    function testTotalSupply() public view {
        assertEq(token.totalSupply(), 100_000 ether);
        assertEq(token.TOTAL_SUPPLY(), 100_000 ether);
    }

    function testBalanceOfDeployer() public view {
        assertEq(token.balanceOf(address(this)), 100_000 ether);
    }

    function testTransfer() public {
        address recipient = address(0x123);
        uint256 amount = 10 ether;

        token.transfer(recipient, amount);
        assertEq(token.balanceOf(recipient), amount);
        assertEq(token.balanceOf(address(this)), 100_000 ether - amount);
    }
}
