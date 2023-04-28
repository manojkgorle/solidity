//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// fallback  & receive functions

// fallback function is called when
//         when the function called from other contract doesnot exist in this contract
//         when sending ether to the contract

// receive function is called when
//         when ether is sent to contract and there exists no data sent
//         if any data was sent, then fallback will be executed

// To receive ether they must be payable

contract fallbackReceive {
    event Log(string func, address sender, uint value, bytes data);

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, msg.data);
    }
}

// use low level interaction in remix to transact, set some value & test using with & without data
// to observe what sort of function is called when the defined casses occur
