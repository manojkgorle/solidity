//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract calculateRoots {
    //proxy sharables
    uint256 public nonce;
    struct result {
        uint256 nonce;
        uint256 roots;
    }
    result[] public Result;
    //individual variables
    uint8 public DECIMALS;
    address public versionContract;
    address public owner;
    string private _version;

    constructor(address _versionContractAddress) {
        versionContract = _versionContractAddress;
        owner = msg.sender;
        _version = "v1";
    }

    //add a fallback function for version2 --> get a good understanding of fallback functions
    //add change decimals
    //focus on preventing decimal over flows
    //challenges:
    // 1) implementing square root functions
    // 2) Math library for solidity
    // 3) dealing with decimals while making calcuations to avoid overflow or underflow error
    //      Version 1: contains all the rough estimates in finding the roots --> ie using the tradional newton method of finding roots
    //      Version 2: importing or creating required math libraries to find all the values under square root and preventing overflow or underflow of decimals while calculating
    function quadratic(uint[3] memory _coefficients) external {
        (bool status, bytes memory data) = versionContract.delegatecall(
            abi.encodeWithSignature("getQuadratic(uint[3])", _coefficients)
        );
        // nonce++;
        // Result.push(result(nonce, data));
    }

    function getVersion() public view returns (string memory) {
        return _version;
    }

    function getVersionContract() public view returns (address) {
        return versionContract;
    }

    function getDecimals() public view returns (uint8) {
        return DECIMALS;
    }

    function updateVersionContract(
        address _newVersionContract,
        string memory _versionName,
        uint8 _decimals
    ) public {
        require(msg.sender == owner, "only owner");
        versionContract = _newVersionContract;
        _version = _versionName;
        DECIMALS = _decimals;
    }
}
