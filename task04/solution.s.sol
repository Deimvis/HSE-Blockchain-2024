  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

interface Factory {
    function deploy() external;
    function solved() external returns (bool);
}

contract Test {
    address public deployer;

    constructor() {
        deployer = msg.sender;
    }
}

contract Solution is Script {
    address payable me = payable(0x92199EeC69Dd43c04103e49D3446052117A12C8a);
    address payable inst = payable(0x7Cb8033f49A2e8446C435E7Ae0CD3cd9d99B73FF);
    // address payable testContract = payable(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    // address payable testContract = payable(0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519);
    address payable testContract = payable(0x1851F41b1bf0F43199Bb3e1B8293E26004417011);

    function run() public {
        uint pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        // console.log(testContract.balance);
        Factory f = Factory(inst);
        // f.deploy();
        // get testContract's address from an error (-vvvvv)
        console.log(testContract.balance);
        unchecked {
            testContract.transfer(1);
        }
        console.log(testContract.balance);
        f.deploy();
        console.log(f.solved());

        vm.stopBroadcast();
    }
}
