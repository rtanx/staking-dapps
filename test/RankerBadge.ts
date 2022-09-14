import { ethers } from "hardhat"
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("RankerBadge", function () {

    async function deployRankerBadgeFixture() {
        const RankerBadge = await ethers.getContractFactory("RankerBadge");
        const [owner, otherAccount] = await ethers.getSigners();
        const contract = await RankerBadge.deploy("Ranker Badge", "RNKR", "https://ipfs.io/ipfs/bafybeihjjkwdrxxjnuwevlqtqmh3iegcadc32sio4wmo7bv2gbf34qs34a/{id}.json", "0x6431FA4B812a2DCC062A38CB55cc7D18135AdEAd");

        await contract.deployed();

        return { RankerBadge, contract, owner, otherAccount };
    }

    it("Should only purchase Gold badge less than equal 25 Gold badge per user", async function () {
        const { contract, otherAccount, owner } = await loadFixture(deployRankerBadgeFixture);
        const goldBadgeId = await contract.callStatic.GOLD();

        // console.log("owner:", await owner.getAddress(), await owner.getBalance());
        // console.log("otherAccount:", await otherAccount.getAddress(), await otherAccount.getBalance());

        const mint = await contract.connect(otherAccount).safeMint(goldBadgeId, 2);
        console.log(mint);
    });

});