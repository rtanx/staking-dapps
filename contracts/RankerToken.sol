// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RankerToken is ERC20 {
    uint256 constant _totalSupply = 1e2 * 1e6 * 1e18; // 100m tokens for distribution

    constructor() ERC20("RankerDAO", "RANKER") {
        _mint(msg.sender, _totalSupply);
    }
}
