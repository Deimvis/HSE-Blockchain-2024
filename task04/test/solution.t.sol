  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";

interface Factory {
    function deploy() external;
}

// contract Test {
//     address public deployer;

//     constructor() {
//         deployer = msg.sender;
//     }
// }

contract Solution is Test {
    address payable me = payable(0x92199EeC69Dd43c04103e49D3446052117A12C8a);
    address payable inst = payable(0x307A1cB3B0908B2D17EF2212f7905f2aBEad149C);
    // address payable testContract = payable(0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496);
    address payable testContract = payable(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function test_run() public {
        uint pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        // console.log(testContract.balance);
        Factory f = Factory(inst);
        // f.deploy();
        // get testContract's address from an error (-vvv)
        console.log(testContract.balance);
        testContract.transfer(0.00001 ether);
        console.log(testContract.balance);
        f.deploy();

        vm.stopBroadcast();
    }
}
