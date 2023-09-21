/*Process:


1. The smart contract will be deployed by the warehouse manager, who will act as the owner of the contract.
2. The owner, having access to the list of orders placed, will utilize the smart contract to mark an order as dispatched and initiate the shipping process through the shipping service.
3. While marking an order as dispatched in the smart contract, the owner will also enter a four-digit OTP (One-Time Password). The OTP can be any number between 999 and 10,000 (excluding those starting with 0).
4. Through some messaging service, the customer who is supposed to receive the order will be provided with the OTP. The customer will need to send the OTP to the smart contract to confirm the acceptance of the order upon its arrival at their address.
5. Using the smart contract, customers will be able to check the status of their orders, which is the number of orders which are shipped but yet to be delivered.
6. It is important to note that the owner's address cannot be considered a customer's address to maintain proper functionality and differentiation within the smart contract.
7. Multiple orders can be shipped to the same address without the nessecity of current order being successfully delivered.
(Note : Multiple orders can be dispatched having the same pin as otp to a customer.)
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShipmentServiceHard {
    address private owner;
    struct Custom{
        mapping(uint=>uint) pins;
        uint completedDeliveries;
    }
    // mapping(address => mapping(uint=>uint)) private pins;
    // mapping(address => uint) private shipped;
    // mapping(address => uint) private completedDeliveries;
    mapping(address => Custom) private pinsaddrs;
    uint private shipped;
    constructor() {
        owner = msg.sender;
    }

    function shipWithPin(address customerAddress, uint pin) public {
        require(msg.sender == owner);
        require(customerAddress != owner);
        require(pin >= 1000 && pin <= 9999);
        // require(pins[customerAddress][pin] == 0);
        // pins[customerAddress][pin] = 1;
        pinsaddrs[customerAddress].pins[pin] = 1;
        // ++shipped[customerAddress];
        ++shipped;
    }

    function acceptOrder(uint pin) public {
        // require(msg.sender != owner);
        Custom storage customer = pinsaddrs[msg.sender];
        require(customer.pins[pin] == 1);
        // pins[msg.sender][pin] = 0;
        ++customer.completedDeliveries;
        // --shipped[msg.sender];
        --shipped;
    }
    function checkStatus(address customerAddress) public view returns (uint) {
        require(msg.sender == owner || msg.sender == customerAddress);
        // return shipped[customerAddress];
        return shipped;
    }

    function totalCompletedDeliveries(address customerAddress) public view returns (uint) {
        require(msg.sender == owner || msg.sender == customerAddress);
        return pinsaddrs[customerAddress].completedDeliveries;
    }
}