// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {Wallet} from "./Wallet.t.sol";

contract CounterTest is Test {
    address payable me = payable(0x92199EeC69Dd43c04103e49D3446052117A12C8a);
    address payable inst = payable(0x307A1cB3B0908B2D17EF2212f7905f2aBEad149C);

    function setUp() public {
    }

    function test_solution() public {
        console.log(me.balance);
        console.log(inst.balance);
    }
}
