// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
}

interface IUniswapV2Pair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface Arbitrage {

    // Router for interaction with pool0
    // address public constant UNI_ROUTER_0 = 0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008;
    // Router for interaction with pool1
    // address public constant UNI_ROUTER_1 = 0x86dcd3293C53Cf8EFd7303B57beb2a3F671dDE98;

    // address public immutable POOL_0;
    // address public immutable POOL_1;
    // uint256 public immutable MINIMUM_PROFIT;
    // uint256 public immutable INITIAL_PLAYER_BALANCE;

    function isSolved(address player) external view returns(bool);
        // return IERC20(IUniswapV2Pair(POOL_0).token1()).balanceOf(player) - INITIAL_PLAYER_BALANCE >= MINIMUM_PROFIT;
}

contract Solution is Script {
    address payable me = payable(0x92199EeC69Dd43c04103e49D3446052117A12C8a);
    address payable inst = payable(0xE7c6c8936e75bdE9502d808E6A335345e632fA73);
    
    address public constant UNI_ROUTER_0 = 0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008;
    address public constant UNI_ROUTER_1 = 0x86dcd3293C53Cf8EFd7303B57beb2a3F671dDE98;
    address public immutable POOL_0 = 0xB80489f20650D0D99E3b6A79A2af2833c1b8062b;
    address public immutable POOL_1 = 0x56625C6E2e526e2A8FA76a150214Bd97119e5e59;
    
    address public token0 = IUniswapV2Pair(POOL_0).token0();
    address public token1 = IUniswapV2Pair(POOL_0).token1();

    function run() public {
        uint pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        console.log("my_balance:", getMyBalance0(), getMyBalance1());
        // earn();
        int256 diff = 1;
        uint256 limit = 1;
        while (diff > 0 && limit > 0) {
          console.log("limit:", limit);
          diff = earn();
          if (diff > 0) console.log("diff:", uint256(diff));
          limit--;
        }

        console.log("is_solved:", Arbitrage(inst).isSolved(me));

        vm.stopBroadcast();
    }
    
    function earn() private returns(int256) {
      uint256 initialBalance = getMyBalance1();
      // find where rate is more steep
      // rate - reserves0 / reserves1
      // convert until rates are equal
      // the first half of tokens convert back using first pool
      // the second half of tokens convert back using second pool

      uint256 reserve00;
      uint256 reserve01;
      (reserve00, reserve01,) = IUniswapV2Pair(POOL_0).getReserves();
      console.log(reserve00, reserve01);
      uint256 reserve10;
      uint256 reserve11;
      (reserve10, reserve11,) = IUniswapV2Pair(POOL_1).getReserves();
      console.log(reserve10, reserve11);
      // rate0 = reserve00 / reserve01;
      // rate1 = reserve10 / reserve11
      // rate0 > rate1 <=> reserve00 * reserve11 > reserve10 * reserve01
      address[] memory path = new address[](2);
      if (reserve00 * reserve11 > reserve10 * reserve01) {
        console.log("POOL 0: token0 <- token1");
        path[0] = token1; path[1] = token0;
        IERC20(token1).approve(UNI_ROUTER_0, getMyBalance1());
        IUniswapV2Router(UNI_ROUTER_0).swapTokensForExactTokens(
          (getMyBalance1()/10)*reserve00/reserve01,
          getMyBalance1(),
          path,
          me,
          block.timestamp+3600
        );
        console.log("my_balance:", getMyBalance0(), getMyBalance1());
        console.log("POOL 1: token0 -> token1");
        path[0] = token0; path[1] = token1;
        IERC20(token0).approve(UNI_ROUTER_1, getMyBalance0());
        IUniswapV2Router(UNI_ROUTER_1).swapExactTokensForTokens(
          getMyBalance0(),
          (getMyBalance0()*reserve11/reserve10)*95/100,
          path,
          me,
          block.timestamp+3600
        );
      } else {
        console.log("POOL 1: token0 <- token1");
        path[0] = token1; path[1] = token0;
        IERC20(token1).approve(UNI_ROUTER_1, getMyBalance1());
        IUniswapV2Router(UNI_ROUTER_1).swapTokensForExactTokens(
          (getMyBalance1()/10)*reserve10/reserve11,
          getMyBalance1(),
          path,
          me,
          block.timestamp+3600
        );
        console.log("my_balance:", getMyBalance0(), getMyBalance1());
        console.log("POOL 0: token0 -> token1");
        path[0] = token0; path[1] = token1;
        IERC20(token0).approve(UNI_ROUTER_0, getMyBalance0());
        IUniswapV2Router(UNI_ROUTER_0).swapExactTokensForTokens(
          getMyBalance0(),
          (getMyBalance0()*reserve01/reserve00)*95/100,
          path,
          me,
          block.timestamp+3600
        );
      }
      
      console.log("my_balance:", getMyBalance0(), getMyBalance1());
      uint256 finalBalance = getMyBalance1();
      console.log("balance update:", initialBalance, "->", finalBalance);
      int256 diff = int256(finalBalance) - int256(initialBalance);
      return diff;
    }
    
    function getMyBalance0() private view returns(uint256) {
      return IERC20(IUniswapV2Pair(POOL_0).token0()).balanceOf(me);
    }
  
    function getMyBalance1() private view returns(uint256) {
      return IERC20(IUniswapV2Pair(POOL_0).token1()).balanceOf(me);
    }
    
    function min(uint256 a, uint256 b) private pure returns(uint256) {
        return a <= b ? a : b;
    }
}
