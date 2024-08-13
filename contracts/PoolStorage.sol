// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
import {PoolStorage} from 'contracts/PoolStorage.sol';
import {DataStruct} from 'contracts/DataStruct.sol';

/**
 * @title Pool Storage
 * @author Yau Kam Fei
 * -This contract:
 *  #act as a Pool to gather all the ether received from LendingPool contract
 *  #received and fallback fucntion in this contract
 *  #send the ether to user from pool while user request loan (can say it as user want to borrow money)
 *  #withdraw the ether (if user want to take out their Collateral)
 */

contract PoolStorage{
    uint256 public totalEther; // Amount Etheruem stored in this Contract
    LendingPool public lendingPool;

    receive() external payable{
        //receive ether from LendingPool and store to totalEther
        totalEther += msg.value;
    }

    function getLendingPoolAddress(address _lendingPool) external{
        lendingPool = LendingPool(_lendingPool);
    }

    /**
     * @notice send Ether to the address
     * @dev Through sendEther function, allow 'LendingPool' Contract to call this function on withdraw and borrow request
     * @param to Send to the address
     * @param amount amoun to send
     * @param isBorrow A boolean to identify the action (true = borrow, false = withdraw)
     */
    function sendEther(address payable to, uint256 amount,bool isBorrow) external{
        DataStruct.LendingData memory userData = lendingPool.getLendingData(msg.sender);
        DataStruct.BorrowingData memory borrowingData = lendingPool.getBorrowingData(msg.sender);

        if(isBorrow){//true = borrow
            if (userData.user != address(0) && borrowingData.user == address(0)) {
                require(amount <= lendingPool.getMaxBorrow(msg.sender), "Borrow amount exceeds 80% of collateral");

            } else if (userData.user != address(0) && borrowingData.user != address(0)) {
                require(borrowingData.debtAmount + amount <= lendingPool.getMaxBorrow(msg.sender), "Borrow amount exceeds 80% of collateral");
            }
            totalEther -= amount;
            to.transfer(amount);
        }else{// false = withdraw
            if (userData.user !=address(0)){
                require(userData.etherBalance >= amount,"Insuficent balance to withdraw");
            }
            totalEther -= amount;
            to.transfer(amount);
        }
    }
}