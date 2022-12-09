import { ethers } from "hardhat";

async function main() {
    const rankerStakingFac = await ethers.getContractFactory("RankerStaking");

    console.log("Deploying ranker staking contract");
    const rankerStaking = await rankerStakingFac.deploy("0xbb3B92333bc2F429d72dF0F7d6D065fBaE9F88c9", "0xbb3B92333bc2F429d72dF0F7d6D065fBaE9F88c9");
    await rankerStaking.deployed();

    console.log("Ranker staking contract deployed to address:", rankerStaking.address);

}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});