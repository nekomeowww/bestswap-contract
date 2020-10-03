// SPDX-License-Identifier: None

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

import "./NFT.sol";

contract NFTClaimer is Ownable {
    NFT public token;

    constructor(
        address _token
    ) public Ownable() {
        token = NFT(_token);
    }

    function claim() external {
        token.mint(msg.sender, 0);
    }
}
