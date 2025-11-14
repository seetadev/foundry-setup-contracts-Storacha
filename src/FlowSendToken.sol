// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title FlowSend Utility Token (FST)
/// @notice Simple ERC20 token with 18 decimals and owner-controlled mint/burn
contract FlowSendToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("FlowSend Utility Token", "FST") Ownable(msg.sender) {
        // Mint initial supply to deployer
        // initialSupply is in *whole tokens*, so convert to 18 decimals
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    /// @notice Mint new tokens (only owner)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }

    /// @notice Burn tokens from an address (only owner)
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount * 10 ** decimals());
    }
}
