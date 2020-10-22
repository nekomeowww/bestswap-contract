/**
 *Submitted for verification at Etherscan.io on 2020-09-16
*/
// SPDX-License-Identifier: None

pragma solidity ^0.6;
import "./StakingRewards.sol";
import "./StakingRewardsAccelerator.sol";

interface IStakingRewards {
    function setDuration(uint256 rewardsDuration) external;
    function notifyRewardAmount(uint256 reward) external;
    function transferOwnership(address newOwner) external;
    function setAccSetter(address setter) external;
}

contract StakingRewardsFactory is Ownable {

    address constant ref = address(0x06DecBa7A077cB103F47ee136CBA0118A5741861);
    address constant rewardToken = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);

    function set_pool_duration(address poolAddress, uint256 rewardsDuration) onlyOwner() public {
        IStakingRewards(poolAddress).setDuration(rewardsDuration);
    }

    function active_pool(address poolAddress, uint amount) onlyOwner() public {
        IStakingRewards(poolAddress).notifyRewardAmount(amount);
    }

    // deploy a staking reward contract for the staking token, and store the reward amount
    // the reward will be distributed to the staking reward contract no sooner than the genesis
    function new_pool(address stakingToken, address yToken, uint amount) onlyOwner() public returns (address) {
        address pool = address(new StakingRewards(rewardToken, stakingToken, yToken, ref));
        IRef(ref).set_admin(pool);
        IERC20 token = IERC20(rewardToken);
        token.transfer(pool, amount);
        return pool;
    }

    function new_accelerator(address VESTtoken, address pool) onlyOwner() public returns (address) {
        address accelerator = address(new StakingRewardsAccelerator(VESTtoken, pool));
        IStakingRewards(pool).setAccSetter(accelerator);
        return accelerator;
    }

    function finalize(address pool) onlyOwner() public {
        IStakingRewards(pool).transferOwnership(msg.sender);
    }
}