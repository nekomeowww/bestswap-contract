// SPDX-License-Identifier: None

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721Burnable.sol";

import "./MinerManager.sol";
import "./NFT.sol";

contract BlindBox is MinerManager, ERC721 {

    NFT public target;

    constructor(
        string memory name,
        string memory symbol,
        address _target
    ) public MinerManager() ERC721(name, symbol) {
        target = NFT(_target);
    }

    function mint(address account) external onlyMiner {
        _mint(account, totalSupply() + 1);
    }
    function burn(uint256 tokenId) external onlyMiner {
        _burn(tokenId);
    }

    function open(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "ERC721: permission deny");
        _burn(tokenId);

        uint256 quality = uint256(keccak256(abi.encode(block.timestamp + block.difficulty))) % 10;
        target.mint(msg.sender, quality);

        emit Opened(tokenId, quality);
    }

    event Opened(uint256 tokenId, uint256 quality);
}
