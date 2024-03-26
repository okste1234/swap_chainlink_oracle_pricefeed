// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {AggregatorV3Interface} from "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// Build a swap that allows users to swapp between 3 different token pairs (Eth, Link, Dai) each token should be transferable between the other two tokens. 

// Write your test using foundry, fork sepolia, then prank holders of these tokens to make use of the swapp. 
// submision deadline is 8am tomorow.

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED
 * VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

/**
 * If you are reading data feeds on L2 networks, you must
 * check the latest answer from the L2 Sequencer Uptime
 * Feed to ensure that the data is accurate in the event
 * of an L2 sequencer outage. See the
 * https://docs.chain.link/data-feeds/l2-sequencer-feeds
 * page for details.
 */

import {IERC20} from "./IERC20.sol";

contract Swap {
    AggregatorV3Interface internal dataFeed;
   IERC20 public daiAddress;
   IERC20 public linkAddress;
   IERC20 public ethAddress;

    AggregatorV3Interface internal ethUsdPriceFeed;
    AggregatorV3Interface internal linkUsdPriceFeed;
    AggregatorV3Interface internal daiUsdPriceFeed;

    constructor(address _ethUsdPriceFeed, address _linkUsdPriceFeed, address _daiUsdPriceFeed,
    address _diaAddr, address _linkAddr, address _ethAddr
    ) {
        ethUsdPriceFeed = AggregatorV3Interface(_ethUsdPriceFeed);
        linkUsdPriceFeed = AggregatorV3Interface(_linkUsdPriceFeed);
        daiUsdPriceFeed = AggregatorV3Interface(_daiUsdPriceFeed);

        daiAddress = IERC20(_diaAddr);
        linkAddress = IERC20(_linkAddr);
        ethAddress = IERC20(_ethAddr);
    }

    event SwapDiaForLink(address _sender, address _addr, uint _tokenAmount);

    function swapDAIforLINK(uint256 _tokenAmount) external {

        require(daiAddress.balanceOf(msg.sender) >= _tokenAmount,"insufficient balance");
        
        int256 daiPrice = getLatestPrice(daiUsdPriceFeed);
        int256 linkPrice = getLatestPrice(linkUsdPriceFeed);

        // Perform swap based on fetched prices
        uint256 linkAmount = (_tokenAmount * uint256(daiPrice)) / uint256(linkPrice);

        require(linkAddress.balanceOf(address(this)) >= linkAmount, "insufficient link token");
        daiAddress.transferFrom(msg.sender, address(this), _tokenAmount);
        linkAddress.transfer(msg.sender, _tokenAmount);

        emit SwapDiaForLink(msg.sender, address(this), _tokenAmount);
        
    }

      function swapLINKforDIA(uint256 _tokenAmount) external {

        require(linkAddress.balanceOf(msg.sender) >= _tokenAmount,"insufficient balance");
        
        int256 linkPrice = getLatestPrice(linkUsdPriceFeed);
        int256 daiPrice = getLatestPrice(daiUsdPriceFeed);

        // Perform swap based on fetched prices
        uint256 diaAmount_ = (_tokenAmount * uint256(linkPrice)) / uint256(daiPrice);

        require(daiAddress.balanceOf(address(this)) >= diaAmount_, "insufficient link token");
        linkAddress.transferFrom(msg.sender, address(this), _tokenAmount);
        daiAddress.transfer(msg.sender, diaAmount_);
        
        emit SwapDiaForLink(msg.sender, address(this), _tokenAmount);
        
    }


      function swapETHforDIA(uint256 _tokenAmount) external {

        require(ethAddress.balanceOf(msg.sender) >= _tokenAmount,"insufficient balance");
        
        int256 ethPrice = getLatestPrice(ethUsdPriceFeed);
        int256 daiPrice = getLatestPrice(daiUsdPriceFeed);

        // Perform swap based on fetched prices
        uint256 diaAmount_ = (_tokenAmount * uint256(ethPrice)) / uint256(daiPrice);

        require(daiAddress.balanceOf(address(this)) >= diaAmount_, "insufficient link token");
        linkAddress.transferFrom(msg.sender, address(this), _tokenAmount);
        daiAddress.transfer(msg.sender, diaAmount_);
        
        emit SwapDiaForLink(msg.sender, address(this), _tokenAmount);
        
    }

      function swapDIAforETH(uint256 _tokenAmount) external {

        require(ethAddress.balanceOf(msg.sender) >= _tokenAmount,"insufficient balance");
        
        int256 daiPrice = getLatestPrice(daiUsdPriceFeed);
        int256 ethPrice = getLatestPrice(ethUsdPriceFeed);

        // Perform swap based on fetched prices
        uint256 ethAmount_ = (_tokenAmount * uint256(daiPrice)) / uint256(ethPrice);

        require(daiAddress.balanceOf(address(this)) >= ethAmount_, "insufficient link token");
        ethAddress.transferFrom(msg.sender, address(this), _tokenAmount);
        ethAddress.transfer(msg.sender, ethAmount_);
        
        emit SwapDiaForLink(msg.sender, address(this), _tokenAmount);
        
    }

       function swapLINKforETH(uint256 _tokenAmount) external {

        require(linkAddress.balanceOf(msg.sender) >= _tokenAmount,"insufficient balance");
        
        int256 linkPrice = getLatestPrice(linkUsdPriceFeed);
        int256 ethPrice = getLatestPrice(ethUsdPriceFeed);

        // Perform swap based on fetched prices
        uint256 ethAmount_ = (_tokenAmount * uint256(linkPrice)) / uint256(ethPrice);

        require(daiAddress.balanceOf(address(this)) >= ethAmount_, "insufficient link token");
        ethAddress.transferFrom(msg.sender, address(this), _tokenAmount);
        ethAddress.transfer(msg.sender, ethAmount_);
        
        emit SwapDiaForLink(msg.sender, address(this), _tokenAmount);
        
    }








    function getLatestPrice(AggregatorV3Interface priceFeed) internal view returns (int256) {
        (
            uint80 roundID, 
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}




    // address public constant ethAddress =
    //     0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9; // Address of Ether (ETH)
    // address public constant linkAddress =
    //     0x779877A7B0D9E8603169DdbD7836e478b4624789; // Address of Chainlink token (LINK)
    // address public constant daiAddress =
    //     0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6; // Address of Dai stablecoin (DAI)
    // mapping(address => bool) public supportedTokens;
    // AggregatorV3Interface public constant ethPriceFeed =
    //     0x694AA1769357215DE4FAC081bf1f309aDC325306; // Address of ETH/USD price feed
    // AggregatorV3Interface public constant linkPriceFeed =
    //     0xc59E3633BAAC79493d908e63626716e204A45EdF; // Address of LINK/USD price feed
    // AggregatorV3Interface public constant daiPriceFeed =
    //     0x14866185B1962B63C3Ea9E03Bc1da838bab34C19; // Address of DAI/USD price feed

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     */
    // constructor() {
    //     dataFeed = AggregatorV3Interface(
    //         0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
    //     );
    // }




  
    //  * Returns the latest answer.
    //  */
    // function getChainlinkDataFeedLatestAnswer() public view returns (int) {
    //     // prettier-ignore
    //     (
    //         /* uint80 roundID */,
    //         int answer,
    //         /*uint startedAt*/,
    //         /*uint timeStamp*/,
    //         /*uint80 answeredInRound*/
    //     ) = dataFeed.latestRoundData();
    //     return answer;
    // }

    // function swap () external {
        
    
