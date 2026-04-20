// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {RandomNumbers} from "../src/RandomNumbersAutoSelect.sol";

contract deployRandomNumbers is Script {
    uint256 constant CHAINLINK_SUBSCRIPTION_ID =
        75603467509357066975583423581295704939628266870686846387510183448846832450619;

    function run() public {
        uint256 subId = CHAINLINK_SUBSCRIPTION_ID;
        vm.startBroadcast();
        RandomNumbers random = new RandomNumbers(subId);
        vm.stopBroadcast();
    }
}
