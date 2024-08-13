// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {PoolStorage} from 'contracts/PoolStorage.sol';
import {DataStruct} from 'contracts/DataStruct.sol';

/**
 * @title core contract of the system
 * @author Yau Kam Fei
 * - User can:
 *  # Supply
 *  # borrow
 *  # Withdraw 
 *  # Repay
 */

contract LendingPool is Ownable{
    using DataStruct for DataStruct.LendingData;
    using DataStruct for DataStruct.BorrowingData;

    IERC20 public token;
    mapping(address => DataStruct.LendingData) public LendingList;
    mapping(address => DataStruct.BorrowingData) public BorrowingList;

    address[] public lendingUsers; // Array to keep track of user addresses
    address[] public borrowingUsers;

    uint256 public tokenRate = 1 ether;
    PoolStorage public poolStorage;
   /**
    * @dev Construtor that initial token address and pool address
    * @param _tokenAddress 
    * @param _poolStorageAddress 
    */
    constructor(address _tokenAddress, address payable _poolStorageAddress) Ownable(msg.sender){
        token = IERC20(_tokenAddress);
        poolStorage = PoolStorage(_poolStorageAddress);
    }

    /**
     * @notice Allows users to Supply their asset(e.g., Ether),
     * - Pre-condition for all borrower, they need to supply their ether as Collateral
     * - Both of them can receive token after supply
     */
    function Supply() external payable{
        uint256 weiAmount = msg.value;
        uint256 numberOfTokens = weiAmount / tokenRate * 10 ** 18;
        token.transferFrom(owner(), msg.sender, numberOfTokens);
        (bool success, ) = address(poolStorage).call{value: weiAmount}("");
        require(success, "Failed to forward Ether to PoolStorage");

        if (LendingList[msg.sender].User == address(0)) {
            // New user
            LendingList[msg.sender] = DataStruct.LendingData({
                User: msg.sender,
                EtherBalance: weiAmount,
                TokenReceived: numberOfTokens
            });
            lendingUsers.push(msg.sender);
        } else {
            // Existing user
            LendingList[msg.sender].EtherBalance += weiAmount;
            LendingList[msg.sender].TokenReceived += numberOfTokens;
        }
    }

    /**
     * @notice This function is used to get Maximum borrowing amount,
     * Calculation is 80% of the Collesteral
     * @param user  The address of the User
     */
    function getMaxBorrow(address user)internal view returns(uint256){
        DataStruct.LendingData memory userData = LendingList[user];
        uint256 maxBorrowAmount = (userData.EtherBalance * 80) / 100;
        return maxBorrowAmount;
    }

    /**
     * @dev Update the amount to repay after user taking loan
     */
    function UpdateInterestAmount() internal {
        uint256 totalDebt = BorrowingList[msg.sender].debtAmount;
        uint256 amountToRepay = BorrowingList[msg.sender].amountToRepay;
        uint256 interestAmount = (totalDebt * 4) / 100;
        BorrowingList[msg.sender].amountToRepay = totalDebt + amountToRepay + interestAmount;

    }

    /**
     * @notice Allows users to borrow specific 'Amount' of the supplied asset
     * Requirment :
     * 
     * - provided that the borrower already supplied enough collateral.
     * - borrowing amount has limited up to 80% of the collateral.
     * 
     * @param uint weiAmount is the amount want to borrow
     */
    function borrow(uint weiAmount)external payable {
        uint256 debtCost = (weiAmount * 4)/100;
    
        if(BorrowingList[msg.sender].user != address(0)){//address exist
            require(BorrowingList[msg.sender].debtAmount < getMaxBorrow(msg.sender),"max Borrowed reach");
            require(BorrowingList[msg.sender].debtAmount + weiAmount <= getMaxBorrow(msg.sender), "Borrow amount exceeds limit");
            BorrowingList[msg.sender].debtAmount += weiAmount;
            UpdateInterestAmount();
            //update amount to repay function
        }else if(LendingList[msg.sender].user != address(0) && BorrowingList[msg.sender].user == address(0)){//first borrow of the address
            require(weiAmount <= getMaxBorrow(msg.sender),"is Over 80%");
            BorrowingList[msg.sender] = DataStruct.BorrowingData({
                user : msg.sender,
                debtAmount : weiAmount,
                amountToRepay : debtCost+weiAmount
            });
            borrowingUsers.push(msg.sender);
        }else{
            revert ("Address Not found");
        }
        poolStorage.sendEther(payable(msg.sender), weiAmount);
    }
    /**
     * @dev
     */
    function repay() external payable {
        uint256 weiAmount = msg.value;
        DataStruct.BorrowingData storage borrowingData = BorrowingList[msg.sender];

        require(borrowingData.debtAmount > 0, "No outstanding debt to repay");
        require(borrowingData.amountToRepay > 0, "No amount to repay");
        require(weiAmount <= borrowingData.amountToRepay, "Repayment amount exceeds debt");

        borrowingData.amountToRepay -= weiAmount;
        borrowingData.debtAmount -= weiAmount;

        (bool success, ) = address(poolStorage).call{value: weiAmount}("");
        require(success, "Failed to transfer Ether to PoolStorage");

        if (borrowingData.amountToRepay == 0) {
            delete BorrowingList[msg.sender];
            for (uint i = 0; i < borrowingUsers.length; i++) {
                if (borrowingUsers[i] == msg.sender) {
                    borrowingUsers[i] = borrowingUsers[borrowingUsers.length - 1];
                    borrowingUsers.pop();
                    break;
                }
            }
        }
    }
    
    /**
     * @notice Allow lender withdraw their Ether from 'PoolStorage'.
     * Requirement :
     * 
     * - the address must have specific amount of ether in the Pool
     * @param weiAmount amount to withdraw from 'PoolStorage'
     */
    function withdraw(uint256 weiAmount) external payable{
        DataStruct.LendingData memory user = LendingList[msg.sender];
        uint256 tokensToReturn = (weiAmount / tokenRate) * 10 ** 18;
        
        require(user.etherBalance >= weiAmount, "Insufficient balance to withdraw..lending");        
        require(token.balanceOf(msg.sender) >= tokensToReturn, "Insufficient token balance to return..lending 2");

        token.transferFrom(msg.sender, owner(), tokensToReturn);

        user.etherBalance -= weiAmount;
        user.tokenReceived -= tokensToReturn;

         if (user.etherBalance == 0) {
            delete LendingList[msg.sender];
            for (uint i = 0; i < lendingUsers.length; i++) {
                if (lendingUsers[i] == msg.sender) {
                    lendingUsers[i] = lendingUsers[lendingUsers.length - 1];
                    lendingUsers.pop();
                    break;
                }
            }
        } else {
            LendingList[msg.sender] = user;
        }
        poolStorage.sendEther123(payable(msg.sender), weiAmount,false);
    }


}