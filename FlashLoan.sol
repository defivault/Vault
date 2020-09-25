pragma solidity ^0.6.6;

import "https://github.com/defivault/Vault/blob/master/DefiVault..sol";
import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/ILendingPoolAddressesProvider.sol";
import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/ILendingPool.sol";

contract Flashloan is FlashLoanReceiverBase {
    
    //address _addressProvider = 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
   

    constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public { }

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
        override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        //
        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `Dai` funds to payback the `_fee` = 0.9 % of loan value!!
        //

        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

   
    function flashloan() public onlyOwner {
        address _asset = 0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108;
        bytes memory data = "";
        uint amount = 1000 ether;   // equals 1000 DAi

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }
}
