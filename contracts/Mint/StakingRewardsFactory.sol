/**
 *Submitted for verification at Etherscan.io on 2020-09-16
*/
// SPDX-License-Identifier: None

pragma solidity ^0.6;
import "./StakingRewards.sol";

interface IStakingRewards {
    function notifyRewardAmount(uint256 reward) external;
}

contract StakingRewardsFactory is Ownable {

    address constant ref = address(0x04A90Bc01B23fe1656abE6c3CC1aBC92d4A27324);
    address constant rewardToken = address(0x36eb1b02cB7Be3ffA1eE7Bd2A3c7D036002730F7);

    // deploy a staking reward contract for the staking token, and store the reward amount
    // the reward will be distributed to the staking reward contract no sooner than the genesis
    function new_pool(address stakingToken, address yToken, uint amount) onlyOwner() public {
        address pool = address(new StakingRewards(rewardToken, stakingToken, yToken, ref));
        IRef(ref).set_admin(pool);
        IERC20 token = IERC20(rewardToken);
        token.transfer(pool, amount);
        IStakingRewards(pool).notifyRewardAmount(amount);
    }
}