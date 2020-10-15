// SPDX-License-Identifier: None
pragma solidity ^0.6;
pragma experimental ABIEncoderV2;

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
    function set_referrer(address r) onlyAdmin() external {
        referrer[tx.origin] = r;
        emit ReferrerSet(tx.origin, r);
    }    
    function add_score(uint d) onlyAdmin() external {
        score[referrer[tx.origin]] += d;
    }

    event ReferrerSet(address indexed origin, address, referrer);
}