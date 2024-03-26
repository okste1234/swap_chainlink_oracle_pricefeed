// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import {Test, console} from "forge-std/Test.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";
import {AggregatorV3Interface} from "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import {Swap} from "../src/Swap.sol";

contract CounterTest is Test {
    Swap public swap;
    AggregatorV3Interface internal ethUsdPriceFeed;
    AggregatorV3Interface internal linkUsdPriceFeed;
    AggregatorV3Interface internal daiUsdPriceFeed;

    address _ethUsdPriceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    address _linkUsdPriceFeed = 0xc59E3633BAAC79493d908e63626716e204A45EdF;

    address _daiUsdPriceFeed = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;

    function setUp() public {
        swap = new Swap(_ethUsdPriceFeed, _linkUsdPriceFeed, _daiUsdPriceFeed);
    }
}
