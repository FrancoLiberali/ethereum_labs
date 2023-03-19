/**
 *Submitted for verification at Etherscan.io on 2023-03-06
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.6 <0.8.0;
pragma abicoder v2;

// 115792089237316195423570985008687907853269984665640564039457584007914, Franco Liberali
// 870360064

contract MyCurrency {
    mapping (address => uint) public currencyBalance;
    
    function getBalance() external view returns(uint) {
        return address(this).balance;
    }
    
    function buy(uint nbCoins,string calldata name) external payable {
        require(msg.value == nbCoins * (1 gwei));
        currencyBalance[msg.sender]+= nbCoins;
        if (!member(msg.sender, owners)) {
            owners.push(msg.sender);
        }
        identity[msg.sender]=name;
    }

    function test(uint nbCoins) external view returns(uint) {
        return nbCoins * (1 gwei);
    }
    
    function sell(uint nbCoins) external{
        require(nbCoins<= currencyBalance[msg.sender]);
        currencyBalance[msg.sender]-= nbCoins;
        msg.sender.transfer(nbCoins*(1 gwei));
    }
    
    // You do not need to read this part. 
    // These maps and functions are for logging purposes only 
    mapping (address => string) identity;
    address[] public owners;
    address contractOwner= msg.sender;

    function showWinners() external view returns(string[] memory){
        uint length= owners.length;
        string[] memory tresult = new string[](length);
        uint nbWin=0;
        for (uint i=0; i<length; i++){
            if (currencyBalance[owners[i]]>10**50)  {
                tresult[nbWin]= identity[owners[i]];
                nbWin++;
            }
        }
        string[] memory result = new string[](nbWin);
        for(uint i=0; i<nbWin; i++){
            result[i]=tresult[i];
        }
        return result;
    }
    
    function member(address s, address[] memory tab) pure private returns(bool){
        uint length= tab.length;
        for (uint i=0;i<length;i++){
            if (tab[i]==s) return true;
        }
        return false;
    }
    
    function getEtherBack() external{
        require(msg.sender==contractOwner);
        payable(contractOwner).transfer(address(this).balance);
    }

    function kill() external{
        require(msg.sender==contractOwner);
        selfdestruct(payable(msg.sender));
    }
}