// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoLend is ERC20, Ownable {
    constructor() ERC20("CryptoLend", "CLTK") Ownable(msg.sender) {
        //10m amount of tokens to Make sure the number of tokens is sufficient to withstand the collateral of 10m ether
        _mint(msg.sender, 10000000 * 10 ** 18);
        
    }
}