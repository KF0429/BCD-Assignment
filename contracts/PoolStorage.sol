// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/**
 * @title Pool Storage
 * -This contract:
 *  #act as a Pool to gather all the ether received from LendingPool contract
 *  #received and fallback fucntion in this contract
 *  #send the ether to user from pool while user request loan (can say it as user want to borrow money)
 *  #withdraw the ether (if user want to take out their Collateral)
 */

contract PoolStorage{
    uint256 public totalEther;

    receive() external payable{
        //receive ether from LendingPool and store to totalEther
        totalEther += msg.value;
    }

    fallback() external payable{
        //receive ether from LendingPool and store to totalEther
        totalEther += msg.value;
    }


    function sendEther() external payable{

    }

    function withdraw() external payable{

    }
}