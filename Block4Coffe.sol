// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;
import "hardhat/console.sol";
pragma abicoder v2;

contract Block4Coffee {
    address owner = msg.sender;
    uint public sellingPrice = 1 * (1 gwei);
    address[] coffeeProviders;

    function addCoffeeProvider(address newCoffeeProvider) external {
        require(msg.sender == owner);

        if (!member(newCoffeeProvider, coffeeProviders)) {
            coffeeProviders.push(newCoffeeProvider);
        }
    }

    function fixCoffeePrice(uint newPrice) external {
        require(msg.sender == owner);
        sellingPrice = newPrice;
    }

    function changeOwner(address a) external {
        require(msg.sender == owner);
        owner = a;
    }

    function kill() external{
        require(msg.sender == owner);
        selfdestruct(payable(msg.sender));
    }

    function member(address s, address[] memory tab) pure private returns(bool) {
        uint length = tab.length;

        for (uint i=0; i<length; i++) {
            if (tab[i] == s) return true;
        }

        return false;
    }
}