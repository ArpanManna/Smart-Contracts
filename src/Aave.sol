// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract AaveInteractions {
    address payable owner;

    IPoolAddressesProvider public immutable provider;
    IPool public immutable pool;

    /**
     * @dev Constructor initializes the contract with Aave's PoolAddressesProvider.
     * @param _addressProvider The address of the Aave PoolAddressesProvider.
     */
    constructor(address _addressProvider) {
        provider = IPoolAddressesProvider(_addressProvider);
        pool = IPool(provider.getPool());
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    /**
     * @notice Supplies liquidity to the Aave pool.
     * @param _tokenAddress The ERC-20 token address to supply.
     * @param _amount The amount of tokens to supply.
     */
    function supplyLiquidity(address _tokenAddress, uint256 _amount) external {
        address asset = _tokenAddress;
        uint256 amount = _amount;
        address onBehalfOf = address(this);
        uint16 referralCode = 0;
        pool.supply(asset, amount, onBehalfOf, referralCode);
    }

    /**
     * @notice Withdraws supplied liquidity from the Aave pool.
     * @param _tokenAddress The ERC-20 token address to withdraw.
     * @param _amount The amount of tokens to withdraw.
     * @return The actual amount withdrawn.
     */
    function withdrawlLiquidity(
        address _tokenAddress,
        uint256 _amount
    ) external returns (uint256) {
        address asset = _tokenAddress;
        uint256 amount = _amount;
        address to = address(this);

        return pool.withdraw(asset, amount, to);
    }

    /**
     * @notice Fetches user account data from Aave.
     * @param _userAddress The address of the user.
     * @return totalCollateralBase The total collateral balance.
     * @return totalDebtBase The total outstanding debt.
     * @return availableBorrowsBase The available borrow limit.
     * @return currentLiquidationThreshold The liquidation threshold.
     * @return ltv The loan-to-value ratio.
     * @return healthFactor The health factor.
     */
    function getUserAccountData(
        address _userAddress
    )
        external
        view
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        return pool.getUserAccountData(_userAddress);
    }

    /**
     * @notice Approves a token for spending by a pool.
     * @param _token The ERC-20 token address.
     * @param _amount The amount to approve.
     * @param _poolContractAddress The address of the pool contract.
     * @return True if approval is successful.
     */
    function approve(
        address _token,
        uint256 _amount,
        address _poolContractAddress
    ) external returns (bool) {
        return IERC20(_token).approve(_poolContractAddress, _amount);
    }

    /**
     * @notice Checks the approved token allowance.
     * @param _token The ERC-20 token address.
     * @param _poolContractAddress The address of the pool contract.
     * @return The amount of tokens allowed.
     */
    function allowance(
        address _token,
        address _poolContractAddress
    ) external view returns (uint256) {
        return IERC20(_token).allowance(address(this), _poolContractAddress);
    }

    function getBalance(address _token) external view returns (uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    /**
     * @notice Withdraws all tokens from the contract to the owner.
     * @param _tokenAddress The ERC-20 token address to withdraw.
     */
    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    receive() external payable {}
}
