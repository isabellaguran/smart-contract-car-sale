pragma solidity ^0.8.0;

contract CarSale {
    address payable public seller;
    address payable public buyer;
    string public carModel;
    uint public price;
    bool public isSold;
    
    event CarPurchased(address buyer, uint price);
    
    constructor(string memory _carModel, uint _price) {
        seller = payable(msg.sender);
        carModel = _carModel;
        price = _price;
        isSold = false;
    }
    
    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can perform this action.");
        _;
    }
    
    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can perform this action.");
        _;
    }
    
    modifier carNotSold() {
        require(!isSold, "The car has already been sold.");
        _;
    }
    
    function purchaseCar() external payable carNotSold {
        require(msg.value >= price, "Insufficient funds to purchase the car.");
        
        buyer = payable(msg.sender);
        isSold = true;
        
        emit CarPurchased(buyer, price);
    }
    
    function withdrawFunds() external onlySeller carNotSold {
        seller.transfer(address(this).balance);
    }
    
    function getContractBalance() external view onlySeller returns (uint) {
        return address(this).balance;
    }
}
