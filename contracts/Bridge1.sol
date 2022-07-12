// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bridge1 {
    
    address public token;
    address public owner;

    constructor (address _token, address _owner) {
        token = _token;
        owner = _owner;
    }

    mapping(string => bool) public __burn;


    function __transfer (address to, uint amount, string memory txhash) external {

        require(
            __burn[txhash] == false,
            "burn already processed"
        );

        require(
            msg.sender == owner,
            "you are not an owner"
        );

        __burn[txhash] = true;

        IERC20(token).transfer(to, amount);
    }

   function __burn_txhash (string memory txhash ) public view returns(bool) {
      return __burn[txhash];
   }
     
}