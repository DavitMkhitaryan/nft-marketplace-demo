// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    // build functions to perform safe math operations

    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 r = x + y;
        require(r >= x, "SafeMath Addition Overflow");
        return r;
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y <= x, "SafeMath Subtraction Overflow");
        uint256 r = x - y;
        return r;
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256) {
        // gas optimization
        if (x == 0) {
            return 0;
        }
        
        uint256 r = x * y;
        require(r / x == y, "SafeMath Multiplication Overflow");
        return r;
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y > 0, "SafeMath Division Overflow");
        uint256 r = x / y;
        return r;
    }

     function modulo(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "SafeMath Modulo Overflow");
        uint256 r = x % y;
        return r;
    }
}
