// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
import {LendingPool} from './LendingPool.sol';
import {DataStruct} from './DataStruct.sol';

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
     * @notice Sends Ether to the specified address.
     * @dev This function allows the 'LendingPool' contract to initiate Ether transfers either for borrowing or withdrawal purposes.
     * @param to The address to which the Ether will be sent.
     * @param amount The amount of Ether to send.
     * @param isBorrow A boolean to identify the action :
     *                  - `true` = borrow, false = withdraw
     *                  - `false` for withdrawing Ether.
     * 
     * Requirements:
     * - If `isBorrow` is true, the borrower must have enough collateral to cover the borrowed amount, capped at 80% of their collateral.
     * - If `isBorrow` is false, the lender must have sufficient Ether balance to withdraw the requested amount.
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