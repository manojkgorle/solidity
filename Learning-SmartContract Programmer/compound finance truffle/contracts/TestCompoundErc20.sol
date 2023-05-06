//SPDX-License-Identifier: MIT

pragma solidity ^0.8;

//compound finance provides: supply, borrow, repay, redeem
//loading all the interfaces, in contract instead of loading externally, should learn loading locally
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface CErc20 {
    function balanceOf(address) external view returns (uint);

    function mint(uint) external returns (uint);

    function exchangeRateCurrent() external returns (uint);

    function supplyRatePerBlock() external returns (uint);

    function balanceOfUnderlying(address) external returns (uint);

    function redeem(uint) external returns (uint);

    function redeemUnderlying(uint) external returns (uint);

    function borrow(uint) external returns (uint);

    function borrowBalanceCurrent(address) external returns (uint);

    function borrowRatePerBlock() external view returns (uint);

    function repayBorrow(uint) external returns (uint);

    function liquidateBorrow(
        address borrower,
        uint amount,
        address collateral
    ) external returns (uint);
}

interface CEth {
    function balanceOf(address) external view returns (uint);

    function mint() external payable;

    function exchangeRateCurrent() external returns (uint);

    function supplyRatePerBlock() external returns (uint);

    function balanceOfUnderlying(address) external returns (uint);

    function redeem(uint) external returns (uint);

    function redeemUnderlying(uint) external returns (uint);

    function borrow(uint) external returns (uint);

    function borrowBalanceCurrent(address) external returns (uint);

    function borrowRatePerBlock() external view returns (uint);

    function repayBorrow() external payable;
}

interface Comptroller {
    function markets(address) external view returns (bool, uint, bool);

    function enterMarkets(address[] calldata) external returns (uint[] memory);

    function getAccountLiquidity(
        address
    ) external view returns (uint, uint, uint);

    function closeFactorMantissa() external view returns (uint);

    function liquidationIncentiveMantissa() external view returns (uint);

    function liquidateCalculateSeizeTokens(
        address cTokenBorrowed,
        address cTokenCollateral,
        uint actualRepayAmount
    ) external view returns (uint, uint);
}

interface PriceFeed {
    function getUnderlyingPrice(address cToken) external view returns (uint);
}

//////////////actual contract begins///////////////
//supply
// borrow
// repay
// redeem

//cerc20 for erc20 & ceth for eth
contract TestCompoundErc20 {
    IERC20 public token;
    CErc20 public cToken;

    constructor(address _token, address _cToken) {
        token = IERC20(_token);
        cToken = CErc20(_cToken);
    }

    function supply(uint _amount) external {
        token.transferFrom(msg.sender, address(this), _amount); //transfering the ERC20 token to this contract
        token.approve(address(cToken), _amount); //approving cToken to spend the erc20 token
        require(cToken.mint(_amount) == 0, "mint failed"); //minting cToken
        //cToken.mint() if success returns 0 else any other number
    }

    function getCTokenBalance() external view returns (uint) {
        return cToken.balanceOf(address(this));
    }

    //not a view function, when even we want exchange rate or supply rate, we need to make a transaction to the cTokencontract to retrieve the value
    //next we are going to get these numbers without making a transaction by making a ***static call***
    function getInfo() external returns (uint exchangeRate, uint supplyRate) {
        //amount of current exchange rate from cToken to underlying
        exchangeRate = cToken.exchangeRateCurrent();
        //amount added to you supply balance this block
        supplyRate = cToken.supplyRatePerBlock();
    }

    function estimateBalanceOfUnderlying() external returns (uint) {
        uint cTokenBal = cToken.balanceOf(address(this));
        uint exchangeRate = cToken.exchangeRateCurrent();
        uint decimals = 8; //WBTC = 8 decimals
        uint cTokenDecimals = 8;

        return
            (cTokenBal * exchangeRate) / 10 ** (18 + decimals - cTokenDecimals);
    }

    //we estimate the balance of token we supply including the exchange rate
    // for this example we are going to use WBTC

    function balanceOfUnderlying() external returns (uint) {
        return cToken.balanceOfUnderlying(address(this));
    }

    //actually we dont have the need of the estimateBalanceOfUnderlying function as compund provides a funciton 'balanceOfUnderlying'
    function redeem(uint _cTokenAmount) external {
        //we supplied a token, we waited a few days and we gathered some intrest, now we want to redeem our token & intrest
        require(cToken.redeem(_cTokenAmount) == 0, "redeem failed");
        // 0 is success
    }
}
//and with this supply and redeem are done
