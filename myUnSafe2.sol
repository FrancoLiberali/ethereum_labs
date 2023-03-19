// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

// Exploitez une faiblesse du contrat permettant a un 
// compte de retirer plus d'ether que le montant envoye.
// when winnerGetsMoneyBack is called, max is not put to 0,
// so once we are the leader we can call winnerGetsMoneyBack
// as many times as we want, getting the money sent by other
// users

contract MyUnSafe2 {
    mapping (address => uint) public currencyBalance;
    address winner;
    uint max = 0;
    
    function balance() external view returns(uint) {
        return address(this).balance;
    }
    
    function sendMoney() external payable {
        currencyBalance[msg.sender] += msg.value;
        if (currencyBalance[msg.sender] > max) {
            winner = msg.sender;
            max = currencyBalance[msg.sender];
        }
    }

    function winnerGetsMoneyBack(address a) external {
        require(a==winner);
        payable(a).transfer(max);
    }   
}