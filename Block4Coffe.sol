// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;
import "hardhat/console.sol";
pragma abicoder v2;

contract Block4Coffee {
    address owner = msg.sender;
    uint public sellingPrice = 1 wei;
    address[] coffeeProviders;
    uint coffeeAmount = 0;

    // user
    mapping (address => int) public accountBalances;
    int minBalance = -10 gwei;

    function sendMoney() external payable {
        accountBalances[msg.sender] += int(msg.value); // TODO try overflow and msg.value bigger than max int256
    }

    function getMoneyBack() external {
        // TODO try when negative
        int balance = accountBalances[msg.sender];
        require(0 < balance);
        accountBalances[msg.sender] = 0;
        payable(msg.sender).transfer(uint(balance));
    }

    function buyCoffee() external {
        require(minBalance <= accountBalances[msg.sender] - int(sellingPrice)); // TODO try underflow and convertion
        accountBalances[msg.sender] -= int(sellingPrice); // TODO try underflow and convertion
    }

    // coffee providers
    function addCoffee(uint amount, string calldata proof) external {
        require(member(msg.sender, coffeeProviders));

        if (isValidProof(proof)) {
            coffeeAmount += amount; // TODO try overflow
            payable(msg.sender).transfer(amount); // TODO try overflow
        }
    }

    // owner

    function addCoffeeProvider(address newCoffeeProvider) external {
        require(msg.sender == owner);

        if (!member(newCoffeeProvider, coffeeProviders)) {
            coffeeProviders.push(newCoffeeProvider);
        }
    }

    function fixCoffeePrice(uint newPrice) external {
        require(msg.sender == owner);
        require(newPrice > 0);
        sellingPrice = newPrice; // TODO try overflow
    }

    function changeOwner(address a) external {
        require(msg.sender == owner);
        owner = a;
    }

    function kill() external{
        require(msg.sender == owner);
        selfdestruct(payable(msg.sender));
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
        return true;
    }
}