// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

library DataStruct{
    struct LendingData{
        // user's address
        address user;
        // amount of collateral
        uint etherBalance;
        // amount of token
        uint tokenReceived;
    }

    struct BorrowingData{
        // user's address
        address user;
        // amount borrowed
        uint debtAmount;
        // amount need to repay back to the pool
        uint amountToRepay;
    }
}