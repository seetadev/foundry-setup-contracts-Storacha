// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Park Pro Token (PPT)
/// @notice Fixed supply of 100,000 PPT, minted once to the deployer. There is no owner and no mint function.
contract PPTToken is ERC20 {
    uint256 public constant TOTAL_SUPPLY = 100_000 ether;

    constructor() ERC20("Park Pro Token", "PPT") {
        _mint(msg.sender, TOTAL_SUPPLY);
    }
}
