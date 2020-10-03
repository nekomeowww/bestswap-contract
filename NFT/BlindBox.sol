// SPDX-License-Identifier: None

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721Burnable.sol";

contract BlindBox is Ownable, ERC721, ERC721Burnable {

    NFT constant public target; // = NFT();

    constructor(
        string memory name,
        string memory symbol,
    ) public Ownable() ERC721(name, symbol) {
    }

    function mint(address account, uint256 quality) external onlyOwner {
        uint256 tokenId = totalSupply() + 1;
        _mint(account, tokenId);
    }
    function open(uint256 tokenId) public override {
        super.burn(tokenId);
        uint quality = uint(keccak256(block.timestamp + block.difficulty)) % 10;
        target.mint(address(this), quality);
    }
}