// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;


contract FundMe {

    uint public minimumUSD = 50 * 1e18;
    address[] public funders;
    mapping(address => uint256) public AddressToAmountFunded;
    
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable {
        require(getConversionRate(msg.value) >= minimumUSD , "Didn't send enough!");

        //Task 1-a
        //Ensure Unique Addresses in the funders array
        require(!checkUniqueAddress(msg.sender), "The address is not unique.");

        funders.push(msg.sender);
        AddressToAmountFunded[msg.sender] += msg.value;
    }

    //function checkUniqueAddress checks whether a given address already exists in the funders array or not
    function checkUniqueAddress(address funder) internal view returns (bool) {
    for (uint i = 0; i < funders.length; i++) {
        if(funders[i] == funder) return true;
    }
    return false;
    
    }


    //without hardcoding the value of 1ETH in USD:
    //we take input from user, thus we do not have to make a new contract every time for the changing prices of 1ETH
    //we are not using a library here as a library cannot have non-constant variables
    uint256 public priceOf1ETH;
    //setting the price of 1ETH

    function setPrice(uint256 _setPrice) public returns(uint256) {
        priceOf1ETH = _setPrice;
        return priceOf1ETH;
    }

    function getPrice() internal view returns(uint256) {
        return uint256 (priceOf1ETH * 1e18);
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint ethPrice = getPrice();
        uint ethAmountinUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountinUSD;
    }



    //Task 1-b
    //Adding the Transfer Ownership Functionality
    //only the owner can transfer ownership to another address here
    //if we remove the onlyOwner modifier, any address can transfer ownership to a different address
    function transferOwnershipFunctionality(address newOwner) public onlyOwner{
        owner = newOwner;
    }

    

    function withdraw() public onlyOwner {
        
        for(uint funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            AddressToAmountFunded[funder] = 0;
        }
        //resetting the array
        funders = new address[](0);
        //actually withdraw the funds

        //call
        (bool callSuccess , ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

        
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Sender is not the owner!");
        _;
    }

}