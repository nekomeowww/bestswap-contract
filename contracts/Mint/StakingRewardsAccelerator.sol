// SPDX-License-Identifier: None

pragma solidity ^0.6;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

import "./StakingRewardsAcceleration.sol";
import "../NFT/NFT.sol";

contract StakingRewardsAccelerator is ReentrancyGuard, IERC721Receiver {
    NFT public stakingToken;
    IStakingRewardsAcceleration public rewardsAcceleration;

    mapping(address => uint256) private _staked;

    constructor(
        address _stakingToken,
        address _rewardsAcceleration
    ) public {
        stakingToken = NFT(_stakingToken);
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

        uint16 quality = uint16(stakingToken.qualityOf(tokenId));

        _staked[msg.sender] = tokenId;
        rewardsAcceleration.setAcc(msg.sender, quality);
        stakingToken.safeTransferFrom(msg.sender, address(this), tokenId);

        emit Staked(msg.sender, tokenId);
    }
    function withdraw() external nonReentrant {
        uint256 tokenId = _staked[msg.sender];
        require(tokenId != 0, "Error: not staked");

        _staked[msg.sender] = 0;
        rewardsAcceleration.setAcc(msg.sender, 0);
        _withdraw(tokenId);
    }
    function _withdraw(uint256 tokenId) internal {
        stakingToken.safeTransferFrom(address(this), msg.sender, tokenId);
        emit Withdrawn(msg.sender, tokenId);
    }

    function onERC721Received(address, address, uint256, bytes calldata) external override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    event Staked(address indexed user, uint256 tokenId);
    event Withdrawn(address indexed user, uint256 tokenId);
}
