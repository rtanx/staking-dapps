// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
