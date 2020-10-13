// SPDX-License-Identifier: None

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MinerManager is Ownable {
    mapping (address => bool) public minters;

    constructor() internal Ownable() {}

    function addMinter(address _minter) public onlyOwner {
        minters[_minter] = true;
    }
    function removeMinter(address _minter) public onlyOwner {
        minters[_minter] = false;
    }

    modifier onlyMiner() {
        require(minters[msg.sender], "Error: only minter");
        _;
    }
}
