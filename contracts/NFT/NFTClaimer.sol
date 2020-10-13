// SPDX-License-Identifier: None

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./NFT.sol";

contract NFTClaimer is Ownable {
    NFT public token;

    constructor(
        address _token
    ) public Ownable() {
        token = NFT(_token);
    }

    function claim() external {
        uint256 quality = uint256(keccak256(abi.encode(block.timestamp + block.difficulty))) % 10;
        token.mint(msg.sender, quality);
    }
}
