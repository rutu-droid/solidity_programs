/*
Token Inheritance: The contract inherits from OpenZeppelin's ERC20 token contract, enabling it to manage and distribute a custom token named "DOH Coin."

Referral Code System: Users are assigned unique referral codes through the userReferralCodes mapping, allowing them to participate in a referral program.

Referral Links: Referral links containing user-specific referral codes are generated and stored in the userReferralLinks mapping. These links help track referrals.

Connecting with Referral Code: Users can connect their wallets to the referral program by providing a valid referral code using the connectWalletWithReferralCode function.

Connecting without Referral Code: Users can also connect their wallets without a referral code through the connectWalletWithoutReferralCode function, where a referral code is generated for them.

Token Purchase and Referral Bonuses: Users can purchase tokens using the purchaseTokens function, with a 5% referral bonus granted to the referrer if the buyer was referred by someone.*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DOHToken is ERC20 {
    using Strings for uint256;

    address public admin;
    address[] public users;
    mapping(address => string) public userReferralCodes;
    mapping(string => address) private referralCodeToUser;
    mapping(address => address) public invitedBy;
    mapping(address => address) public referralReferredBy;
    mapping(address => uint256) public purchaseAmounts;
    mapping(address => string) public userReferralLinks; // Added mapping to store referral links

    constructor() ERC20("DOH Coin", "DOH") {
        admin = msg.sender;
    }

    function generateRandomReferralCode() private view returns (string memory) {
        uint256 randomValue = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, users.length)));
        return randomValue.toString();
    }
    
    function generateReferralLinkWithReferralCode(string memory ownReferralCode, string memory invitedReferralCode) private pure returns (string memory) {
        return string(abi.encodePacked("https://dohcoin.io/?own_user_referral_code=", ownReferralCode, "&invited_user_referral_code=", invitedReferralCode));
    }

    function generateReferralLinkWithoutReferralCode(string memory ownReferralCode) private pure returns (string memory) {
        return string(abi.encodePacked("https://dohcoin.io/?own_user_referral_code=", ownReferralCode));
    }

    function connectWalletWithReferralCode(string memory _referralCode) external {
        require(bytes(_referralCode).length > 0, "Referral code cannot be empty");
        require(bytes(userReferralCodes[msg.sender]).length == 0, "Wallet already connected");
        require(msg.sender != admin, "Admin cannot connect wallet");
        require(referralCodeToUser[_referralCode] != address(0), "Invalid referral code");

        userReferralCodes[msg.sender] = generateRandomReferralCode();
        users.push(msg.sender);

        address inviter = referralCodeToUser[_referralCode];
        invitedBy[msg.sender] = inviter;
        if (inviter != address(0)) {
            referralReferredBy[msg.sender] = referralReferredBy[inviter];
        } else {
            referralReferredBy[msg.sender] = msg.sender;
        }

        // Generate referral link and store it
        string memory ownReferralCode = userReferralCodes[msg.sender];
        string memory invitedReferralCode = userReferralCodes[inviter];
        string memory referralLink = generateReferralLinkWithReferralCode(ownReferralCode, invitedReferralCode);
        userReferralLinks[msg.sender] = referralLink;
    }

    function connectWalletWithoutReferralCode() external {
        require(bytes(userReferralCodes[msg.sender]).length == 0, "Wallet already connected");
        require(msg.sender != admin, "Admin cannot connect wallet");

        string memory referralCode = generateRandomReferralCode();
        userReferralCodes[msg.sender] = referralCode;
        referralCodeToUser[referralCode] = msg.sender;

        users.push(msg.sender);

        // Generate referral link and store it
        string memory ownReferralCode = userReferralCodes[msg.sender];
        string memory referralLink = generateReferralLinkWithoutReferralCode(ownReferralCode);
        userReferralLinks[msg.sender] = referralLink;
    }

    function purchaseTokens(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than zero");
        require(msg.sender != address(0), "Invalid address");

        _mint(msg.sender, _amount);
        purchaseAmounts[msg.sender] += _amount;

        address referrer = referralReferredBy[msg.sender];
        uint256 referralBonus = _amount * 5 / 100; // 5% referral bonus
        if (referrer != address(0)) {
            _mint(referrer, referralBonus);
            purchaseAmounts[referrer] += referralBonus;
        }
    }
}