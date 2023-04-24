//SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;

contract etherStore{
    mapping(address => uint256) public balance;
    function deposit() external payable{
        balance[msg.sender] += msg.value;
    }
    function withdraw(uint256 _amount) external payable{
        require(balance[msg.sender] >= _amount);
        (bool sent, ) = msg.sender.call{value : _amount}("");
        require(sent, "transact failed");
        balance[msg.sender] -= _amount;
    }
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
}



///what is being done in this exercise: reentracy attack in solidity:
// we created a basic deposit & withdraw function 
//we are implementing an attack on the smart contract which is possesing a loop hole
//we are sending 1 ether with the call to deposit & immedietly withdrawing the 1 ether
//The withdraw function makes a call to the msg.sender contract, with the value sent to be withdrawn
//so a fall back function is created in attack contract, such that the we withdraw all the balance of the etherstore contract, from the fall back function (fallback should return executing then only the call is assumed to be completed) when call is returned as complete then we update the balance of the user in balances sheet
//
//so reentrance is completed by emptying the balance sheet of the contract