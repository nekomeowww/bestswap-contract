// SPDX-License-Identifier: None

pragma solidity ^0.6;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol";

import "./StakingRewardsAcceleration.sol";

contract StakingRewardsAccelerator is ReentrancyGuard, ERC1155Receiver {
    IERC1155 public stakingToken;
    IStakingRewardsAcceleration public rewardsAcceleration;

    mapping(address => uint256) private _staked;
    mapping(uint256 => uint16) private qualityMap;

    constructor(
        address _stakingToken,
        address _rewardsAcceleration
    ) public {
        stakingToken = IERC1155(_stakingToken);
        rewardsAcceleration = IStakingRewardsAcceleration(_rewardsAcceleration);

        qualityMap[1] = 500;
        qualityMap[2] = 1500;
        qualityMap[3] = 3000;
    }

    function getStaked(address account) external view returns (uint256) {
        return _staked[account];
    }

    function stake(uint256 tokenId) external nonReentrant {
        uint256 stakedTokenId = _staked[msg.sender];
        if (stakedTokenId != 0) {
            _withdraw(stakedTokenId);
        }

        uint16 quality = qualityMap[tokenId];

        _staked[msg.sender] = tokenId;
        rewardsAcceleration.setAcc(msg.sender, quality);
        stakingToken.safeTransferFrom(msg.sender, address(this), tokenId, 1, "");

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
        stakingToken.safeTransferFrom(address(this), msg.sender, tokenId, 1, "");
        emit Withdrawn(msg.sender, tokenId);
    }

    function onERC1155Received(address, address, uint256, uint256, bytes calldata) external override returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(address, address, uint256[] calldata, uint256[] calldata , bytes calldata) external override returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    event Staked(address indexed user, uint256 tokenId);
    event Withdrawn(address indexed user, uint256 tokenId);
}
