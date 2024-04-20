// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is Ownable(msg.sender), ERC721Holder {

    IERC721 public nftContract;
    IERC20 public Tokens;
  
  struct NftForSale {
        uint256 price;
        address seller;
    }  

    mapping(uint256 => NftForSale) public nftPrices;
    
    event NFTListed(uint256 indexed tokenId, uint256 price, address seller);
    event NFTSold(uint256 indexed tokenId, address indexed buyer, uint256 price);
   

    constructor(address _nftContract, address _Tokens) {
        nftContract = IERC721(_nftContract);
        Tokens = IERC20(_Tokens);
    }

    function listNFTForSale(uint256 tokenId, uint256 price) external {
        require(nftContract.ownerOf(tokenId) == msg.sender, "You don't own this NFT");
        require(price > 0, "Price must be greater than zero");
        nftPrices[tokenId].price = price;
        nftPrices[tokenId].seller= msg.sender;
        nftContract.safeTransferFrom(msg.sender,address(this), tokenId);
        emit NFTListed(tokenId, price ,msg.sender);
    }

    function buyNFT(uint256 tokenId) external {
        uint256 price = nftPrices[tokenId].price;
        require(price > 0, "NFT not listed for sale");
        address seller = nftContract.ownerOf(tokenId);
        require(seller != address(0), "Invalid seller address");
        
        Tokens.transferFrom(msg.sender, seller, price);
        nftContract.safeTransferFrom(address(this), msg.sender, tokenId);

        delete nftPrices[tokenId];
        emit NFTSold(tokenId, msg.sender, price);
    }

    function removeFromListing(uint256 tokenId)external{
        require(nftContract.ownerOf(tokenId) == msg.sender,"you don't own this nft");
        nftContract.safeTransferFrom(address(this), msg.sender , tokenId);
        delete nftPrices[tokenId];
    }

    function setNewContract( address _nftContract ,address _token) external{
        nftContract = IERC721(_nftContract);
        Tokens = IERC20(_token);
    }
}


//mytoken contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
    }
}


//mynft

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable(msg.sender) {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function mint(address to, uint256 tokenId) external onlyOwner {
        _safeMint(to, tokenId);
    }
}
