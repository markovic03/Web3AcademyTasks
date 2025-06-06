// scripts/deploy.js
const { ethers } = require("hardhat");

async function main() {
  const NFTMembership = await ethers.getContractFactory("NFTMembership");
  const nftContract = await NFTMembership.deploy("DAO Membership NFT", "DAO");
  await nftContract.deployed();
  console.log("NFT Contract deployed to:", nftContract.address);

  const DAO = await ethers.getContractFactory("DAO");
  const daoContract = await DAO.deploy(nftContract.address);
  await daoContract.deployed();
  console.log("DAO Contract deployed to:", daoContract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
