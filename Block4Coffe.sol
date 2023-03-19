// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;
import "hardhat/console.sol";
pragma abicoder v2;

contract Block4Coffee {
    address owner = msg.sender;
    uint sellingPrice = 1 * (1 gwei);

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
}