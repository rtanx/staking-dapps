// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RankerBadge is ERC721, ERC721Enumerable, Ownable {
    IERC20 public tokenAddress;
    using Counters for Counters.Counter;
    mapping(uint256 => uint256) private _tokenIdToTokenType;

    Counters.Counter private _tokenIds;

    uint256 public constant BRONZE = 1;
    uint256 public constant SILVER = 2;
    uint256 public constant GOLD = 3;
    uint256 public constant GAMING = 4;

    struct Badge {
        uint256 tokenType;
        uint256 priceRate;
        uint256 maxSupply;
        Counters.Counter totalSupply;
        bool hasMaxSupply;
    }

    Badge[4] private badges;

    string public baseTokenURI;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI,
        address _tokenAddress
    ) ERC721(name_, symbol_) {
        setBaseURI(baseURI);
        tokenAddress = IERC20(_tokenAddress);

        badges[0] = Badge(BRONZE, 20_000, 0, Counters.Counter(0), false);
        badges[1] = Badge(SILVER, 100_000, 0, Counters.Counter(0), false);
        badges[2] = Badge(GOLD, 500_000, 25, Counters.Counter(0), true);
        badges[3] = Badge(GAMING, 500, 0, Counters.Counter(0), false);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        baseURI,
                        Strings.toString(_tokenIdToTokenType[tokenId])
                    )
                )
                : "";
    }

    function safeMint(uint256 tokenType, uint256 amount) public {
        require(
            tokenType <= badges.length && tokenType > 0,
            "Token doesn't exists"
        );
        uint256 index = tokenType - 1;
        uint256 totalMintedPerBadge = badges[index].totalSupply.current();

        if (badges[index].hasMaxSupply) {
            require(
                totalMintedPerBadge + amount <= badges[index].maxSupply,
                "Not enough NFTs to mint, reached maximum supply"
            );
        }
        tokenAddress.transferFrom(
            msg.sender,
            address(this),
            amount * badges[index].priceRate
        );
        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = _tokenIds.current();
            _safeMint(msg.sender, tokenId);
            _tokenIdToTokenType[tokenId] = tokenType;
            _tokenIds.increment();
            badges[index].totalSupply.increment();
        }
    }

    function withdraw() public onlyOwner {
        require(tokenAddress.balanceOf(address(this)) > 0, "Balance is 0");
        tokenAddress.transfer(
            msg.sender,
            tokenAddress.balanceOf(address(this))
        );
    }

    function totalSupplyPerBadge(uint256 tokenType)
        public
        view
        returns (uint256)
    {
        require(
            tokenType <= badges.length && tokenType > 0,
            "Token doesn't exists"
        );

        uint256 index = tokenType - 1;
        return badges[index].totalSupply.current();
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
