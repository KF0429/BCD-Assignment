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
    DataStruct.LendingData [] LendingList;

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

        for(uint i = 0;i<LendingList.length;i++){
            if(LendingList[i].User ==msg.sender){
                LendingList[i].EtherBalance += weiAmount;
                LendingList[i].TokenReceived += numberOfTokens;
                addressExist = true;
                break;
            }
            if(!addressExist){
                LendingList.push(DataStruct.LendingData({
                User:msg.sender,
                EtherBalance:msg.value,
                TokenReceived:numberOfTokens
                }));
            }
        }
    }
}