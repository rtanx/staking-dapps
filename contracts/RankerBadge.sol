// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RankerBadge is ERC1155, Ownable {
    struct Badge {
        uint256 id;
        uint256 suppliesPerAddr;
        uint256 rate;
    }

    uint256 public constant BRONZE = 1;
    uint256 public constant SILVER = 2;
    uint256 public constant GOLD = 3;
    uint256 public constant GAMING = 4;

    Badge[] public badges;

    mapping(address => uint8) private _whiteList;

    constructor()
        ERC1155(
            "https://ipfs.io/ipfs/bafybeihjjkwdrxxjnuwevlqtqmh3iegcadc32sio4wmo7bv2gbf34qs34a/{id}.json"
        )
    {
        // for value < 0, that's mean unlimited supplies for one address
        badges.push(Badge(BRONZE, type(uint256).max, 0.05 ether));
        badges.push(Badge(SILVER, type(uint256).max, 0.05 ether));
        badges.push(Badge(GOLD, 25, 0.05 ether));
        badges.push(Badge(GAMING, type(uint256).max, 0.05 ether));
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function uri(uint256 _tokenId)
        public
        pure
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "https://ipfs.io/ipfs/bafybeihjjkwdrxxjnuwevlqtqmh3iegcadc32sio4wmo7bv2gbf34qs34a/",
                    Strings.toString(_tokenId),
                    ".json"
                )
            );
    }

    function mint(uint256 id, uint256 amount) public payable {
        require(id < badges.length && id > 0, "Token doesn't exists");
        uint256 index = id - 1;
        require(
            balanceOf(msg.sender, id) < badges[index].suppliesPerAddr,
            "Has reached the maximum supply per address for a given tokenId"
        );
        require(
            msg.value >= amount * badges[index].rate,
            "Not enough ether to mint"
        );
        _mint(msg.sender, id, amount, "0x00");
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }

    function setWhiteList(address[] calldata addresses, uint8 numAllowedToMint)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < address.length; i++) {
            _whiteList[addresses[i]] = numAllowedToMint;
        }
    }
}
