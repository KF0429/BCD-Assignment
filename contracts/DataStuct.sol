// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

library DataStruct{
    struct LendingData{
        address User;
        uint EtherBalance;
        uint TokenReceived;
    }
}