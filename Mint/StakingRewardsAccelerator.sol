// SPDX-License-Identifier: None

pragma solidity ^0.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";

import "./StakingRewardsAcceleration.sol";

contract StakingRewardsAccelerator is ReentrancyGuard {
    IERC721 public NFT;
    IStakingRewardsAcceleration public rewardsAcceleration;

    mapping(address => uint256) private _staked;

    constructor(
        address _NFT,
        address _rewardsAcceleration
    ) public {
        NFT = IERC721(_NFT);
        rewardsAcceleration = IStakingRewardsAcceleration(_rewardsAcceleration);
    }

    function getStaked(address account) external view returns (uint256) {
        return _staked[account];
    }

    function stake(uint256 tokenId) external nonReentrant {
        uint256 stakedTokenId = _staked[msg.sender];
        if (stakedTokenId != 0) {
            _withdraw(stakedTokenId);
        }

        uint256 quality = NFT.qualityOf(tokenId);

        _staked[msg.sender] = tokenId;
        rewardsAcceleration.setAcc(msg.sender, quality);
        NFT.safeTransferFrom(msg.sender, address(this), tokenId);

        emit Staked(msg.sender, tokenId);
    }
    function withdraw() external nonReentrant {
        uint256 tokenId = _staked[msg.sender];
        require(tokenId != 0, "Error: not staked");

        rewardsAcceleration.setAcc(msg.sender, 0);
        _withdraw(tokenId);
    }
    function _withdraw(uint256 tokenId) internal {
        NFT.safeTransferFrom(address(this), msg.sender, tokenId);
        emit Withdrawn(msg.sender, tokenId);
    }

    event Staked(address indexed user, uint256 tokenId);
    event Withdrawn(address indexed user, uint256 tokenId);
}
