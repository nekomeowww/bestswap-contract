// SPDX-License-Identifier: None
pragma solidity ^0.6;

contract Ref {

    mapping(address => address) public referrer;
    mapping(address => uint) public score;
    mapping(address => bool) public admin;

    modifier onlyAdmin() {
        require(admin[msg.sender], "You 're not admin");
        _;
    }

    constructor() public  {
        admin[msg.sender] = true;        
    }

    function set_admin(address a) onlyAdmin() external {
        admin[a] = true;
    }

    function set_referrer(address a, address b) onlyAdmin() external {
        referrer[a] = b;
    }
    
    function add_score(address a, uint d) onlyAdmin() external {
        score[a] += d;
    }
}