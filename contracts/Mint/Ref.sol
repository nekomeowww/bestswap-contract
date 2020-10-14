pragma solidity ^0.6;

contract Ref {
    mapping(address => address) public referrer;
    mapping(address => uint) public score;
    mapping(address => bool) public admin;

    modifier onlyAdmin() {
        _;
    }

    constructor() public  {
        admin[msg.sender] = true;        
    }

    function set_admin(address a) onlyAdmin() external {
        admin[a] = true;
    }

    function set_referrer(address a, address b) onlyAdmin() external {
    }
    
    function add_score(uint d) onlyAdmin() external {
    }
}