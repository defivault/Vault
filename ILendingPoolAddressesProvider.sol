pragma solidity ^0.6.6;

interface ILendingPoolAddressesProvider {
    function getLendingPoolCore() external view returns (address payable);
    function getLendingPool() external view returns (address);
}