// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract HelloContract {
    function sayHi() public pure returns (bytes memory) {
        return "HelloFromHSE";
    }
}
