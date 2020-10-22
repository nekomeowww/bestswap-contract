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
    IRef constant public ref = IRef(0x06DecBa7A077cB103F47ee136CBA0118A5741861);
    IERC20 constant public token = IERC20(0x10747e2045a0ef884a0586AC81558F43285ea3c7);     

    function claim() external {
        uint score = ref.scoreOf(msg.sender);
        uint delta = score - claimed[msg.sender];
        token.transfer(msg.sender, delta.mul(7).div(100));
        claimed[msg.sender] = score;
    }
}