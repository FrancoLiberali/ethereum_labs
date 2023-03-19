// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

// Exploitez deux faiblesses (differentes) pour:
// 1) une qui permet de vider le contrat de l'ether depose par d'autres
// user1 buys
// user2 sells -> we can simple sell without buying and get money
// 2) une qui vous permet d'avoir une currencyBalance gigantesque!
// as we sell without buying, 0-amount gives us a big number because it is a uint
// user3 do sell 1 and we obtain:
// currencyBalance[user3] = uint256: 115792089237316195423570985008687907853269984665640564039457584007913129639935

contract MyUnSafe1 {
    mapping (address => uint) public currencyBalance;

    function balance() external view returns(uint) {
        return address(this).balance;
    }
    
    function buy() external payable {
        currencyBalance[msg.sender] += msg.value;
    }
    
    function sell(uint amount) external {
        payable(msg.sender).transfer(amount);
        currencyBalance[msg.sender] -= amount;
    }
}