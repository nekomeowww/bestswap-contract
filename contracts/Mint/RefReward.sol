// SPDX-License-Identifier: None
pragma solidity ^0.6;
import "@openzeppelin/contracts/math/SafeMath.sol";

interface IRef {
    function scoreOf(address a) external view returns (uint);
}

interface IERC20 {
    function transfer(address to, uint value) external returns (bool);
}

contract RefReward {

    using SafeMath for uint;

    mapping(address => uint) public claimed;
    IRef constant public ref = IRef(0x75b82728C5a4f1CbfdC8b27C7DCFfea9bBa3F613);
    IERC20 constant public token = IERC20(0x36eb1b02cB7Be3ffA1eE7Bd2A3c7D036002730F7);     

    function claim() external {
        uint score = ref.scoreOf(msg.sender);
        uint delta = score - claimed[msg.sender];
        token.transfer(msg.sender, delta.mul(7).div(100));
        claimed[msg.sender] = score;
    }
}