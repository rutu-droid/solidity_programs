// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RightAngledTriangle {
    //To check if a triangle with side lenghts a,b,c is a right angled triangle
    function check(uint a, uint b, uint c) public pure returns (bool) {
            // Check the Pythagorean theorem: a^2 + b^2 = c^2 for a right-angled triangle
        if (a > 0 && b > 0 && c > 0) {
            if (a * a + b * b == c * c || a * a + c * c == b * b || b * b + c * c == a * a) {
                return true;
            }
        }
        return false;
    }
}