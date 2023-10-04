/*
The smart contract should maintain a list of properties.
Each property should have details such as its ID, description, location, price, and current owner.
Anyone should be able to list a new property, but only the property owner should be able to update or delete it.
Users should be able to buy available properties by sending the exact amount of ether for the property price.
On a successful sale, the previous owner should receive the funds, and ownership should transfer to the new owner.
There should be an admin who can remove properties in case they violate terms.*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyMarketplace {
    address public admin;
    
    struct Property {
        uint256 id;
        string description;
        string location;
        uint256 price;
        address owner;
    }
    
    Property[] public properties;
    
    constructor() {
        admin = msg.sender;
    }
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
    
    modifier onlyOwner(uint256 propertyId) {
        require(msg.sender == properties[propertyId].owner, "Only the owner can call this function");
        _;
    }
    
    event PropertyListed(uint256 indexed id, string description, string location, uint256 price, address owner);
    event PropertyUpdated(uint256 indexed id, string newDescription, string newLocation, uint256 newPrice, address newOwner);
    event PropertyRemoved(uint256 indexed id);
    event PropertySold(uint256 indexed id, address indexed previousOwner, address indexed newOwner, uint256 price);
    
    function listProperty(string memory _description, string memory _location, uint256 _price) external {
        uint256 propertyId = properties.length;
        properties.push(Property(propertyId, _description, _location, _price, msg.sender));
        emit PropertyListed(propertyId, _description, _location, _price, msg.sender);
    }
    
    function updateProperty(uint256 propertyId, string memory _newDescription, string memory _newLocation, uint256 _newPrice) external onlyOwner(propertyId) {
        Property storage property = properties[propertyId];
        property.description = _newDescription;
        property.location = _newLocation;
        property.price = _newPrice;
        emit PropertyUpdated(propertyId, _newDescription, _newLocation, _newPrice, msg.sender);
    }
    
    function removeProperty(uint256 propertyId) external onlyAdmin {
        require(propertyId < properties.length, "Property does not exist");
        emit PropertyRemoved(propertyId);
        delete properties[propertyId];
    }
    
    function buyProperty(uint256 propertyId) external payable {
        Property storage property = properties[propertyId];
        require(property.owner != address(0), "Property does not exist");
        require(msg.value == property.price, "Incorrect amount sent");
        
        address previousOwner = property.owner;
        property.owner = msg.sender;
        
        payable(previousOwner).transfer(msg.value);
        emit PropertySold(propertyId, previousOwner, msg.sender, msg.value);
    }
    
    function getPropertyCount() external view returns (uint256) {
        return properties.length;
    }
}