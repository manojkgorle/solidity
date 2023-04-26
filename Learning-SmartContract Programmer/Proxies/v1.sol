//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract v1 {
    uint256 public nonce;
    struct result {
        uint256 nonce;
        uint256 roots;
    }
    result[] public Result;

    function getQuadratic(
        uint[3] memory _coefficients
    ) external returns (uint) {
        // ax^2 + bx + c
        //newton method take an estimate --> initial guess
        uint256 feval;
        uint256 fderv;
        uint256 x0; //iguess equals zero
        uint256 xn;
        uint256 diff = 10000;
        uint256 toll = 1;
        // get its derivative & value computed
        //find the difference & compare with tollerance
        //render in while loop
        while (diff > toll) {
            feval = getValue(_coefficients, x0);
            fderv = getDerivative(_coefficients, x0);
            xn = x0 - feval / fderv;
            if (xn > x0) {
                diff = xn - x0;
            } else {
                diff = x0 - xn;
            }
        }
        nonce++;
        Result.push(result(nonce, xn));
        return xn;
    }

    function getDerivative(
        uint[3] memory _coefficients,
        uint256 _val
    ) internal pure returns (uint) {
        return 2 * _coefficients[0] * _val + _coefficients[1];
    }

    function getValue(
        uint[3] memory _coefficients,
        uint256 _val
    ) internal pure returns (uint) {
        return
            (_coefficients[0]) *
            (_val ** 2) +
            _coefficients[1] *
            _val +
            _coefficients[2];
    }
}
