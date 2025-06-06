// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMembership is ERC721URIStorage, Ownable {
    uint256 public tokenIdCounter;
    uint256 public constant mintPrice = 0.01 ether;
    mapping(address => bool) public hasMinted;

    // Konstruktor prima adresu vlasnika (DAO ugovor)
    constructor(address initialOwner) ERC721("DAO Membership NFT", "DAO") Ownable(initialOwner) {}

    // Funkcija za mintovanje prvog NFT-a od strane vlasnika bez placanja
    function mintInitial(address to, string memory tokenURI) external onlyOwner {
        require(tokenIdCounter == 0, "Initial NFT already minted");

        tokenIdCounter++;
        uint256 newTokenId = tokenIdCounter;

        _mint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        hasMinted[to] = true;
    }

    // Mintovanje za ostale korisnike, uz placanje mintPrice
    function mintMembership(string memory tokenURI) public payable {
        require(!hasMinted[msg.sender], "Already minted");
        require(msg.value == mintPrice, "Wrong mint price");

        tokenIdCounter++;
        uint256 newTokenId = tokenIdCounter;

        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        hasMinted[msg.sender] = true;
    }
}

