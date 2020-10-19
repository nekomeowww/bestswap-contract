/**
 *Submitted for verification at Etherscan.io on 2020-09-16
*/
// SPDX-License-Identifier: None

pragma solidity ^0.6;
import "./StakingRewards.sol";

interface IRef {
    function set_referrer(address r) external;
    function add_score(uint d) external;
    function set_admin(address a) external;
}

contract StakingRewardsFactory {

    address constant ref = address(0x04A90Bc01B23fe1656abE6c3CC1aBC92d4A27324);
    address constant rewardToken = address(0x36eb1b02cb7be3ffa1ee7bd2a3c7d036002730f7);

    // deploy a staking reward contract for the staking token, and store the reward amount
    // the reward will be distributed to the staking reward contract no sooner than the genesis
    function new_pool(address stakingToken, uint amount) {
        address pool = address(new StakingRewards(rewardToken, stakingToken, ref));
        ref.set_admin(pool);
        IERC20 token = IERC20(rewardToken);
        token.transfer(pool, amount);
        pool.notifyRewardAmount(amount);
    }
}