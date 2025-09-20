// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract PPTToken is ERC20, Ownable {
    address public medInvoiceContract;

    constructor(uint256 initialSupply) ERC20("Park Pro Token", "PPT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == medInvoiceContract, "Only medInvoiceContract can call this function");
        _mint(to, amount);
    }

     function setMedInvoiceContract(address _medInvoiceContract) external onlyOwner {
        require(
            medInvoiceContract == address(0),
            "MedInvoiceContract contract already set"
        );
        medInvoiceContract = _medInvoiceContract;
    }

}
