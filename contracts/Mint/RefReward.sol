// SPDX-License-Identifier: None
pragma solidity ^0.6;

interface IRef {
    function scoreOf(address a) external view returns (uint);
}

contract RefReward {

    mapping(address => uint) public claimed;
    IRef constant public ref = IRef(0); // TODO: add ref address

    function claim() external {
        uint score = ref.scoreOf(msg.sender);
        uint delta = score - claimed[msg.sender];
        // TODO: transfer delta token to msg.sender
        // ...
        claimed[msg.sender] = score;
    }
}