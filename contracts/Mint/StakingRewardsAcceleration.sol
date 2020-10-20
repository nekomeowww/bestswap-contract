// SPDX-License-Identifier: None

pragma solidity ^0.6;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IStakingRewardsAcceleration {
    function accOf(address account) external view returns (uint16);
    function setAcc(address account, uint16 acc) external;
    function setAccSetter(address setter) external;

    event AccelerationUpdated(address indexed user, uint256 amount);
}

abstract contract StakingRewardsAcceleration is Ownable, IStakingRewardsAcceleration {
    address public accSetter;
    mapping(address => uint16) private _acc;

    function accOf(address account) public override view returns (uint16) {
        return _acc[account];
    }

    function setAcc(address account, uint16 acc) external override {
        require(msg.sender == accSetter, "Caller is not AccSetter");
        _acc[account] = acc;
    }
    function setAccSetter(address setter) override external onlyOwner {
        accSetter = setter;
    }
}
