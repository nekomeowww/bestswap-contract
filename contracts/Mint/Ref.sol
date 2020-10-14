// SPDX-License-Identifier: None
pragma solidity ^0.6;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/EnumerableSet.sol";

contract Ref {
    using EnumerableSet for EnumerableSet.AddressSet;

    mapping(address => address) public referrer;
    mapping(address => uint) public score;
    mapping(address => bool) public admin;
    mapping(address => EnumerableSet.AddressSet) private subordinate;

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
    
    function add_subordinate(address a, address r) onlyAdmin() external {
        subordinate[r].add(a);
    }

    function subordinateOf(address refer) external view returns (address[] memory subs) {
        uint arrLength = subordinate[refer].length();
        address[] memory subsArray = new address[](arrLength);
        
        for (uint i = 0; i < arrLength; i++) {
            subsArray[i] = subordinate[refer].at(i);
        }

        return subsArray;
    }
}