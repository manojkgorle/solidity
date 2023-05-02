//SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract Enum {
    enum Status {
        None, //defult value by default
        Pending,
        Shipped,
        Completed,
        Rejected,
        Canceled
    }

    Status public status;

    struct Order {
        address buyer;
        Status status;
    }

    Order[] public orders;

    function get() public view returns (Status) {
        return status;
    }

    function set(Status _status) external {
        status = _status;
    }

    function ship() external {
        status = Status.Shipped;
    }

    function reset() external {
        delete status;
    }

    //how to handle these transactions: when passing an enum, the value in numbers corresponding to the order declared should be called
    // None, //defult value by default  0)
    // Pending,     1)
    // Shipped,     2)
    // Completed,   3)
    // Rejected,    4)
    // Canceled     5)

    //    function calls --> set(3) --> sets status to completed
}
