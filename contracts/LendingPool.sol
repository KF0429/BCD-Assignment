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
    mapping(address => DataStruct.BorrowingData) public BorrowingList;
    // Array to keep track of user addresses
    address[] public lendingUsers; 
    address[] public borrowingUsers;

    uint256 public tokenRate = 1 ether;
    PoolStorage public poolStorage;
   

    constructor(address _tokenAddress, address payable _poolStorageAddress) Ownable(msg.sender){
        token = IERC20(_tokenAddress);

        poolStorage = PoolStorage(_poolStorageAddress);
    }

    /**
     * @notice Allows users to Supply their asset(e.g., Ether) 
     * -Lender is supplying for interest.
     * -Pre-condition for all borrower, they need to supply their ether as Collateral
     * -Both of them can receive token after supply
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
            lendingUsersusers.push(msg.sender);
        } else {
            // Existing user
            LendingList[msg.sender].EtherBalance += weiAmount;
            LendingList[msg.sender].TokenReceived += numberOfTokens;
        }
    }

    function getMaxBorrow(address user)internal view returns(uint256){
        DataStruct.LendingData memory userData = LendingList[user];
        uint256 maxBorrowAmount = (userData.EtherBalance * 80) / 100;
        return maxBorrowAmount;
    }

    /**
     * @notice Allows users to borrow specific 'Amount' of the supplied asset, 
     * provided that the borrower already supplied enough collateral.
     * -borrowing amount has limited up to 80% of the collateral.
     * @param uint weiAmount is the amount want to borrow
     */
    function borrow(uint weiAmount)external payable {
        uint256 MaxBorrowAmount= getMaxBorrow(msg.sender);
        require(weiAmount <= MaxBorrowAmount, "Borrow amount exceeds 80% of collateral");
        poolStorage.sendEther(payable(msg.sender), weiAmount);
        
        if (BorrowingList[msg.sender].User == address(0)) {// New user
            BorrowingList[msg.sender] = DataStruct.BorrowingData({
                User: msg.sender,
                debtAmount : weiAmount
            });
            borrowingUsers.push(msg.sender);
        } else {// Existing user
            BorrowingList[msg.sender].debtAmount += weiAmount;
        }
    }

    function calDebtCost() internal {

    }

    function repay() external payable {

    }
    
    function withdraw() external payable{

    }


}