// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

contract Solution is Script {
    address payable inst = payable(0x123);
    ContractName public c;
    address public me = 0x92199EeC69Dd43c04103e49D3446052117A12C8a;

    address payable hacker = payable(0xADB99998d6eD41b6a09C3155085463f54DE888D2);
    address payable me = payable(0x92199EeC69Dd43c04103e49D3446052117A12C8a);

    function setUp() public {}

    function run() public {
        uint pk = vm.envUint("HACKER_PRIVATE_KEY");
        vm.startBroadcast(pk);

        console.log(hacker.balance);
        me.transfer(0.0009 ether);
        console.log(hacker.balance);

        vm.stopBroadcast();
    }
}
