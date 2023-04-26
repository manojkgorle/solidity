//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/*
A calls B, sends 100 wei
    B calls C, sends 50 wei
A --> B --> C
            msg.sender = B
            msg.value = 50 wei
            execute code on C's State variables
            use ETH in C

A calls B, sends 100 wei
        B delegate calls C
A --> B --> C
        msg.sender = A
        msg.value = 100 wei
        execute code on B's state variables
        use ETH in B

*/
// know what is function signature ?

contract TestDelegateCall {
    //address public owner;
    uint256 public num; //a
    address public sender; //b
    uint256 public value; //c

    function setVars(uint256 _num) external payable {
        num = 2 * _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCall {
    uint256 public num; //A
    address public sender; //B
    uint256 public value; //C

    function setVars(address _test, uint256 _num) external payable {
        // _test.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
        ); //delegate call returns two variables just as call bool for status & bytes data
        require(success, "delegatecall failed");
    }
}
//hack solidity accesing private data

/* while using delegate call storage slots of the contracts are linked in the way they are defined from the begining order*/
/*a -> A, b -> B, c-> C 
if on top of 'a' d is declared the storage slot allocation changes as d -> A, a -> B, b -> C, c -> ?(nowhere) 
*/
