// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

//Task 1-c
//removal of chain-link integration
//import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getPrice() internal pure returns(uint256) {
        //in order to remove chain-link integration, we have to feed in the value of 1ETH in USD
        //price of 1ETH in USD (as per https://data.chain.link/ethereum/mainnet/crypto-usd/eth-usd on 28-06-2023 23:45) = $1,847.83 ~ $1,848
        int256 price = 1848;
        return uint256 (price * 1e18);
        //**since hardcoding the price will lead to the need to make new contracts for the everchanging prices of 1ETH in USD**
        //**I have made a separate file, FundMe2 where the value of 1ETH has to be set by the user**
        //**The PriceConverter library is not used in FundMe2 as a libarary cannot have non-constant variables**
    }

    function getConversionRate(uint256 ethAmount) internal pure returns(uint256) {
        uint ethPrice = getPrice();
        uint ethAmountinUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountinUSD;
    }

}
