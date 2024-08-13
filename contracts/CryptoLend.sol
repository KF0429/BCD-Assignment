// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title CrytoLend Token
 * @author Yau Kam Fei
 * @dev Implementation of the ERC20 CryptoLend token with an initial supply minted to the owner.
 *         This token contract is Ownable, meaning the deployer of the contract has special privileges
 *         such as minting more tokens or transferring ownership.
 * 
 * The token is Initial Supply with 10,000,000 tokens
 * 
 */


contract CryptoLend is ERC20, Ownable {
    /**
     * @dev constructor that gives contract deployer all of the existing tokens.
     */
    constructor() ERC20("CryptoLend", "CLTK") Ownable(msg.sender) {
        _mint(msg.sender, 10000000 * 10 ** 18);
        
    }
}