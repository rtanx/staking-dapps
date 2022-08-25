import { ethers } from "hardhat"
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("RankerBadge", function () {

    async function deployRankerBadgeFixture() {
        const RankerBadge = await ethers.getContractFactory("RankerBadge");
        const [owner, otherAccount] = await ethers.getSigners();

        const contract = await RankerBadge.deploy("0x6431FA4B812a2DCC062A38CB55cc7D18135AdEAd");

        await contract.deployed();

        return { RankerBadge, contract, owner, otherAccount };
    }

    it("Should only purchase Gold badge less than equal 25 Gold badge per user", async function () {
        const { contract } = await loadFixture(deployRankerBadgeFixture);
        const goldBadgeId = await contract.callStatic.GOLD();

        console.log(goldBadgeId);
    });

});