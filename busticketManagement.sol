// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BusTicketManagement {
    address public owner;
    uint8[20] public seats; // Array to represent seat availability (0 for available, 1 for booked)

    // Mapping to track the number of tickets booked by each address
    mapping(address => uint8) public ticketsBooked;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Function to book seats
    function bookSeats(uint8[] memory seatNumbers) public {
        require(seatNumbers.length > 0 && seatNumbers.length <= 4, "Invalid number of seats.");
        require(ticketsBooked[msg.sender] + seatNumbers.length <= 4, "You cannot book more than 4 seats.");

        for (uint8 i = 0; i < seatNumbers.length; i++) {
            uint8 seatNumber = seatNumbers[i];
            require(seatNumber >= 1 && seatNumber <= 20, "Invalid seat number.");
            require(seats[seatNumber - 1] == 0, "Seat is already booked.");
            seats[seatNumber - 1] = 1; // Mark the seat as booked
            ticketsBooked[msg.sender]++;
        }
    }

    // Function to get available seats
    function showAvailableSeats() public view returns (uint8[] memory) {
        uint8[] memory available = new uint8[](20);
        uint8 count = 0;

        for (uint8 i = 0; i < 20; i++) {
            if (seats[i] == 0) {
                available[count] = i + 1;
                count++;
            }
        }

        uint8[] memory result = new uint8[](count);
        for (uint8 i = 0; i < count; i++) {
            result[i] = available[i];
        }

        return result;
    }

    // Function to check seat availability
    function checkAvailability(uint8 seatNumber) public view returns (bool) {
        require(seatNumber >= 1 && seatNumber <= 20, "Invalid seat number.");
        return seats[seatNumber - 1] == 0;
    }

    // Function to get booked tickets for the caller
    function myTickets() public view returns (uint8[] memory) {
        uint8[] memory booked = new uint8[](ticketsBooked[msg.sender]);
        uint8 count = 0;

        for (uint8 i = 0; i < 20; i++) {
            if (seats[i] == 1) {
                booked[count] = i + 1;
                count++;
            }
        }

        return booked;
    }
}