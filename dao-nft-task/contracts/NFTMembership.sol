// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMembership is ERC721URIStorage, Ownable {
    uint256 public currentTokenId = 1;
    uint256 public constant MINT_PRICE = 0.01 ether;
    mapping(address => bool) public hasMinted;

    constructor() ERC721("DAO Membership", "DAOM") {}

    function mint(string memory tokenURI) external payable {
        require(!hasMinted[msg.sender], "Only one NFT per address allowed");
        require(msg.value == MINT_PRICE, "Mint price is 0.01 ETH");

        _safeMint(msg.sender, currentTokenId);
        _setTokenURI(currentTokenId, tokenURI);
        hasMinted[msg.sender] = true;
        currentTokenId++;
    }
}

