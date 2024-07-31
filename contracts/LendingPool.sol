// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {PoolStorage} from 'contracts/PoolStorage.sol';
import {DataStruct} from 'contracts/DataStruct.sol';

/**
 * @title core contract of the system
 * - User can:
 *  # Supply
 *  # borrow
 *  # Withdraw 
 *  # Repay
 */

contract LendingPool is Ownable{
    using DataStruct for DataStruct.LendingData;

    IERC20 public token;
    // DataStruct.LendingData [] LendingList;
    mapping(address => DataStruct.LendingData) public LendingList;
    address[] public users; // Array to keep track of user addresses

    uint256 public tokenRate = 1 ether;
    PoolStorage public poolStorage;
   

    constructor(address _tokenAddress, address payable _poolStorageAddress) Ownable(msg.sender){
        token = IERC20(_tokenAddress);

        poolStorage = PoolStorage(_poolStorageAddress);
    }

    function Supply() external payable{
        //step 1: applying the buy token Concept
        uint256 weiAmount = msg.value;
        uint256 numberOfTokens = weiAmount / tokenRate * 10 ** 18;
        //msg.sender is the person who using this contarct
        token.transferFrom(owner(), msg.sender, numberOfTokens);
        //step 2: send ether to PoolSTorage
        (bool success, ) = address(poolStorage).call{value: weiAmount}("");
        require(success, "Failed to forward Ether to PoolStorage");
        //step 3: store the user's Data to the LendingList array (e.g., user address, etherbalance, tokens received)
        // step 3.1 check array existing of the wallet address
        bool addressExist = false;

        if (LendingList[msg.sender].User == address(0)) {
            // New user
            LendingList[msg.sender] = DataStruct.LendingData({
                User: msg.sender,
                EtherBalance: weiAmount,
                TokenReceived: numberOfTokens
            });
            users.push(msg.sender);
        } else {
            // Existing user
            LendingList[msg.sender].EtherBalance += weiAmount;
            LendingList[msg.sender].TokenReceived += numberOfTokens;
        }
    }

    /**
     * @notice Allows users to borrow specific 'Amount' of the supplied asset, 
     * provided that the borrower already supplied enough collateral.
     * -borrowing amount has limited up to 80% of the collateral.
     */
    function borrow()external payable {

    }
}