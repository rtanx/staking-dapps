// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RankerBadge is ERC721, ERC721Enumerable, Ownable {
    IERC20 public tokenAddress;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    uint256 private _maxSupply;
    uint256 private _priceRate;
    bool private _isNoMaxSupply;

    string public baseTokenURI;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI,
        address _tokenAddress,
        uint256 priceRate_,
        uint256 maxSupply_,
        bool isNoMaxSupply_
    ) ERC721(name_, symbol_) {
        setBaseURI(baseURI);
        tokenAddress = IERC20(_tokenAddress);

        _priceRate = priceRate_;
        _maxSupply = maxSupply_;
        _isNoMaxSupply = isNoMaxSupply_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function safeMint(uint256 amount) public payable {
        uint256 currentMinted = _tokenIds.current();
        if (!_isNoMaxSupply) {
            require(
                currentMinted + amount <= _maxSupply,
                "Not enough NFTs to mint, reached maximum supply"
            );
        }
        tokenAddress.transferFrom(
            msg.sender,
            address(this),
            amount * _priceRate
        );
        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = _tokenIds.current();
            _safeMint(msg.sender, tokenId);
            _tokenIds.increment();
        }
    }

    function withdraw() public onlyOwner {
        require(tokenAddress.balanceOf(address(this)) > 0, "Balance is 0");
        tokenAddress.transfer(
            msg.sender,
            tokenAddress.balanceOf(address(this))
        );
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
