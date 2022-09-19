import { ethers } from "hardhat";

async function main() {
  const rankerTokenFac = await ethers.getContractFactory("RankerToken");

  // deploy ranker token
  console.log("Deploying ranker token...");

  const rankerToken = await rankerTokenFac.deploy();
  await rankerToken.deployed();
  console.log("Ranker Token Contract deployed to address:", rankerToken.address);

  const rankerBadgeFac = await ethers.getContractFactory("RankerBadge")

  // deploy ranker badge
  console.log("Deploying ranker badge...");
  const rankerBadge = await rankerBadgeFac.deploy("Ranker Badge", "RNKR", "https://ipfs.io/ipfs/bafybeihjjkwdrxxjnuwevlqtqmh3iegcadc32sio4wmo7bv2gbf34qs34a/{id}.json", rankerToken.address);
  await rankerBadge.deployed();

  console.log("Ranker Badge Contract deployed to address:", rankerBadge.address);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
