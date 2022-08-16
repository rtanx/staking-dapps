// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Context.sol";

interface Token {
    function transfer(address receipent, uint256 amount)
        external
        returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function transferFrom(
        address sender,
        address receipent,
        uint256 amount
    ) external returns (uint256);
}

contract StakeRANKER is Pausable, Ownable, ReentrancyGuard {
    Token rankerToken;

    // 30 days
    uint256 public planDuration = 30 * 24 * 60 * 60;
    // 180 days
    uint256 _planExpired = 180 * 24 * 60 * 60;

    uint8 public interestRate = 1 << 5;
    uint256 public planExpired;
    uint8 public totalStakers;

    struct StakeInfo {
        uint256 startTS;
        uint256 endTS;
        uint256 amount;
        uint256 claimed;
    }

    event Staked(address indexed from, uint256 amount);
    event Claimed(address indexed from, uint256 amount);

    mapping(address => StakeInfo) public stakeInfos;
    mapping(address => bool) public addressStaked;

    constructor(Token _tokenAddress) {
        require(
            address(_tokenAddress) != address(0),
            "Invalid address: address cannot be 0"
        );
        rankerToken = _tokenAddress;
        _planExpired = block.timestamp + _planExpired;
        totalStakers = 0;
    }
}
