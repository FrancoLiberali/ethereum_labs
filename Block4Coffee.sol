// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;
import "hardhat/console.sol";

contract Block4Coffee {
    uint public sellingPrice = 1 gwei;
    uint public coffeeAmount = 0;

    // user
    mapping (address => int) public accountBalances;
    int minBalance = -10 gwei;

    function sendMoney() external payable {
        accountBalances[msg.sender] += int(msg.value);
    }

    function getMoneyBack() external {
        int balance = accountBalances[msg.sender];
        require(0 < balance, "You don't have money in your balance");
        accountBalances[msg.sender] = 0;
        payable(msg.sender).transfer(uint(balance));
    }

    function buyCoffee() external {
        require(coffeeAmount > 0, "No coffees available");
        require(minBalance <= accountBalances[msg.sender] - int(sellingPrice), "Not enoght money");
        accountBalances[msg.sender] -= int(sellingPrice);
        coffeeAmount -= 1;
    }

    // coffee providers
    address[] coffeeProviders;
    uint returnPerCoffee = 1 gwei;

    function addCoffee(uint amount, string calldata proof) external {
        require(member(msg.sender, coffeeProviders), "You are not a coffee provider");
        require(isValidProof(proof), "Not valid proof");

        coffeeAmount += amount;
        payable(msg.sender).transfer(amount * returnPerCoffee);
    }

    // owner
    address owner = msg.sender;

    function addCoffeeProvider(address newCoffeeProvider) external {
        require(msg.sender == owner, "You are not the owner");

        if (!member(newCoffeeProvider, coffeeProviders)) {
            coffeeProviders.push(newCoffeeProvider);
        }
    }

    function fixCoffeePrice(uint newPrice) external {
        require(msg.sender == owner, "You are not the owner");
        require(newPrice > 0);
        sellingPrice = newPrice * (1 gwei);
    }

    function changeOwner(address a) external {
        require(msg.sender == owner, "You are not the owner");
        owner = a;
    }

    // private

    function member(address s, address[] memory tab) pure private returns(bool) {
        uint length = tab.length;

        for (uint i=0; i<length; i++) {
            if (tab[i] == s) return true;
        }

        return false;
    }

    function isValidProof(string calldata proof) pure private returns(bool) {
        bytes memory stringBytes = bytes(proof);
        return stringBytes.length != 0;
    }
}