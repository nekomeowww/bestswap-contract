// SPDX-License-Identifier: None

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721Burnable.sol";

contract NFT is Ownable, ERC721, ERC721Burnable {
    mapping (address => bool) public minters;

    mapping(uint256 => uint256) private _quailities;

    constructor(
        string memory name,
        string memory symbol
    ) public Ownable() ERC721(name, symbol) {
    }

    function addMinter(address _minter) public onlyOwner {
        minters[_minter] = true;
    }
    function removeMinter(address _minter) public onlyOwner {
        minters[_minter] = false;
    }

    function mint(address account, uint256 quality) external {
        require(minters[msg.sender], "Error: only minter allowed");

        uint256 tokenId = totalSupply() + 1;
        _mint(account, tokenId);
        setQuality(tokenId, quality);
    }

    function qualityOf(uint256 tokenId) external view returns (uint256) {
        return _quailities[tokenId];
    }
    function setQuality(uint256 tokenId, uint256 quality) public {
        require(minters[msg.sender], "Error: only minter allowed");
        _quailities[tokenId] = quality;
    }
}
