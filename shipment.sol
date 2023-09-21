//problem:

/*

1. The smart contract will be deployed by the warehouse manager, who will act as the owner of the contract.
2. The owner, having access to the list of orders placed, will utilize the smart contract to mark an order as dispatched and initiate the shipping process through the shipping service.
3. While marking an order as dispatched in the smart contract, the owner will also enter a four-digit OTP (One-Time Password). The OTP can be any number between 999 and 10,000 (excluding those starting with 0).
4. Through some messaging service, the customer who is supposed to receive the order will be provided with the OTP. The customer will need to send the OTP to the smart contract to confirm the acceptance of the order upon its arrival at their address.
5. Using the smart contract, customers will be able to check the status of their orders. The possible order statuses are as follows:
"no orders placed" if the customer has not placed any orders.
"shipped" if the order has been dispatched.
"delivered" if the last order has been successfully delivered.
6. It is important to note that the owner's address cannot be considered a customer's address to maintain proper functionality and differentiation within the smart contract.
7. For ease of implementation, in this phase of migration, until one order is completely delivered, another order cannot be dispatched to the same address.
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShipmentService {
    address private owner;
    mapping(address => uint) private orders;
    mapping(address => uint) private completedDeliveries;

    constructor() {
        owner = msg.sender;
    }

    function shipWithPin(address customerAddress, uint pin) public {
        require(msg.sender == owner);
        require(customerAddress != owner);
        require(pin >= 1000 && pin <= 9999);
        require(orders[customerAddress] == 0);

        orders[customerAddress] = pin;
    }

    function acceptOrder(uint pin) public {
        require(orders[msg.sender] == pin);
        orders[msg.sender] = 0;
        ++completedDeliveries[msg.sender];
    }

    function checkStatus(address customerAddress) public view returns (string memory) {
        require(msg.sender == owner || msg.sender == customerAddress);
        uint order = orders[customerAddress];
        if (order == 0 && completedDeliveries[customerAddress] > 0) {
            return "delivered";
        } else if (order > 0) {
            return "shipped";
        } else {
            return "no orders placed";
        }
    }

    function totalCompletedDeliveries(address customerAddress) public view returns (uint) {
        require(msg.sender == owner || msg.sender == customerAddress);
        return completedDeliveries[customerAddress];
    }
}
