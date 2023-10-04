// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGamingEcosystemNFT {
    function mintNFT(address to) external;
    function burnNFT(uint256 tokenId) external;
    function transferNFT(uint256 tokenId, address from, address to) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract BlockchainGamingEcosystem {
    address public owner;
    IGamingEcosystemNFT public nftContract;
    
    struct Game {
        string gameName;
        bool exists;
        uint256 price;
    }

    struct Player {
        string userName;
        uint256 balance;
        uint256[] ownedNFTs;
    }

    mapping(address => Player) public players;
    mapping(uint256 => Game) public games;
    uint256 public nextTokenID = 0;

    constructor(address _nftAddress) {
        owner = msg.sender;
        nftContract = IGamingEcosystemNFT(_nftAddress);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    modifier notOwner() {
        require(msg.sender != owner, "Owner cannot perform this action.");
        _;
    }

    modifier uniqueUserName(string memory userName) {
        require(bytes(players[msg.sender].userName).length == 0, "Player with this address already registered.");
        require(bytes(userName).length >= 3, "User name must have a minimum length of 3 characters.");
        _;
    }

    function registerPlayer(string memory userName) public notOwner uniqueUserName(userName) {
        players[msg.sender].userName = userName;
        players[msg.sender].balance = 1000;
    }

    function createGame(string memory gameName, uint256 gameID) public onlyOwner {
        require(!games[gameID].exists, "Game with this ID already exists.");
        games[gameID] = Game(gameName, true, 250);
    }

    function removeGame(uint256 gameID) public onlyOwner {
        require(games[gameID].exists, "Game with this ID does not exist.");
        Game storage game = games[gameID];
        for (uint256 i = 0; i < players[msg.sender].ownedNFTs.length; i++) {
            uint256 tokenID = players[msg.sender].ownedNFTs[i];
            if (tokenID / 1000 == gameID) {
                players[msg.sender].balance += game.price;
                nftContract.burnNFT(tokenID);
                removeAssetFromPlayer(msg.sender, tokenID);
            }
        }
        delete games[gameID];
    }

    function buyAsset(uint256 gameID) public {
        require(games[gameID].exists, "Game with this ID does not exist.");
        Game storage game = games[gameID];
        require(players[msg.sender].balance >= game.price, "Insufficient balance.");
        
        nftContract.mintNFT(msg.sender);
        uint256 tokenID = nextTokenID++;
        players[msg.sender].ownedNFTs.push(tokenID);
        players[msg.sender].balance -= game.price;
        game.price = (game.price * 110) / 100;
    }

    function sellAsset(uint256 tokenID) public {
        address ownerAddress = nftContract.ownerOf(tokenID);
        require(ownerAddress == msg.sender, "You do not own this asset.");
        uint256 gameID = tokenID / 1000;
        require(games[gameID].exists, "Game associated with this asset does not exist.");
        Game storage game = games[gameID];
        players[msg.sender].balance += game.price;
        nftContract.burnNFT(tokenID);
        removeAssetFromPlayer(msg.sender, tokenID);
    }

    function transferAsset(uint256 tokenID, address to) public {
        address ownerAddress = nftContract.ownerOf(tokenID);
        require(ownerAddress == msg.sender, "You do not own this asset.");
        require(bytes(players[to].userName).length > 0, "Recipient is not a registered player.");
        nftContract.transferNFT(tokenID, msg.sender, to);
        removeAssetFromPlayer(msg.sender, tokenID);
    }

    function viewProfile(address playerAddress) public view returns (string memory userName, uint256 balance, uint256 numberOfNFTs) {
        Player memory player = players[playerAddress];
        userName = player.userName;
        balance = player.balance;
        numberOfNFTs = player.ownedNFTs.length;
    }

    function viewAsset(uint256 tokenID) public  returns (address , string memory gameName, uint256 price) {
        address ownerAddress = nftContract.ownerOf(tokenID);
        owner = ownerAddress;
        uint256 gameID = tokenID / 1000;
        gameName = games[gameID].gameName;
        price = games[gameID].price;
    }

    function removeAssetFromPlayer(address playerAddress, uint256 tokenID) internal {
        uint256[] storage ownedNFTs = players[playerAddress].ownedNFTs;
        for (uint256 i = 0; i < ownedNFTs.length; i++) {
            if (ownedNFTs[i] == tokenID) {
                ownedNFTs[i] = ownedNFTs[ownedNFTs.length - 1];
                ownedNFTs.pop();
                return;
            }
        }
    }
}