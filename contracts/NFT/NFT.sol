// SPDX-License-Identifier: None

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";

import "./MinerManager.sol";

contract NFT is MinerManager, ERC721, ERC721Burnable {
    mapping(uint256 => uint256) private _quailities;

    uint256 private _nextTokenId;

    constructor(
        string memory name,
        string memory symbol
    ) public MinerManager() ERC721(name, symbol) {
        _nextTokenId = 1;
    }

    function mint(address account, uint256 quality) external onlyMiner {
        uint256 tokenId = _nextTokenId;
        _mint(account, tokenId);
        _nextTokenId = tokenId + 1;

        if (quality != 0) {
            setQuality(tokenId, quality);
        }
    }
    function burn(uint256 tokenId) public override {
        super.burn(tokenId);
        delete _quailities[tokenId];
    }

    function qualityOf(uint256 tokenId) external view returns (uint256) {
        return _quailities[tokenId];
    }
    function setQuality(uint256 tokenId, uint256 quality) public onlyMiner {
        require(_quailities[tokenId] != quality, "Error: same quality");
        _quailities[tokenId] = quality;

        emit QualityUpdated(tokenId, quality);
    }

    event QualityUpdated(uint256 tokenId, uint256 quality);
}
