import { ethers } from "hardhat";

async function main(deploy_token: boolean,) {
  if (deploy_token) {
    const rankerTokenFac = await ethers.getContractFactory("RankerToken");

    // deploy ranker token
    console.log("Deploying ranker token...");

    const rankerToken = await rankerTokenFac.deploy();
    await rankerToken.deployed();
    console.log("Ranker Token Contract deployed to address:", rankerToken.address);
  }
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const rankerBadgeFac = await ethers.getContractFactory("RankerToken")

  // deploy ranker badge
  console.log("Deploying ranker badge...");
  const rankerBadge = await rankerBadgeFac.deploy();
  await rankerBadge.deployed();

  console.log("Ranker Badge Contract deployed to address:", rankerBadge.address);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main(false).catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
