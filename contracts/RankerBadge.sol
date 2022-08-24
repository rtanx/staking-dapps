// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RankerBadge is ERC1155, Ownable {
    IERC20 public tokenAddress;

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

    constructor(address _tokenAddress)
        ERC1155(
            "https://ipfs.io/ipfs/bafybeihjjkwdrxxjnuwevlqtqmh3iegcadc32sio4wmo7bv2gbf34qs34a/{id}.json"
        )
    {
        tokenAddress = IERC20(_tokenAddress);
        // for value < 0, that's mean unlimited supplies for one address
        badges.push(Badge(BRONZE, type(uint256).max, 20 * 10**3)); // 20.000 $RANKER
        badges.push(Badge(SILVER, type(uint256).max, 100 * 10**3)); // 100.000 $RANKER
        badges.push(Badge(GOLD, 25, 500 * 10**3)); // 500.000 $RANKER
        badges.push(Badge(GAMING, type(uint256).max, 500)); // 500 $RANKER
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        tokenAddress = IERC20(_tokenAddress);
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
        tokenAddress.transferFrom(
            msg.sender,
            address(this),
            amount * badges[index].rate
        );
        _mint(msg.sender, id, amount, "0x00");
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }
}
