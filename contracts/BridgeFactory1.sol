// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./Bridge1.sol";

contract BridgeFactory1 {

   event CreateBridge(address token, uint time, address bridge);

   address owner;


   mapping(address => address) public _bridges;

   constructor() {
     owner = msg.sender;
   }

   function __create_bridge (address token) public {

       if(_bridges[token] == address(0)) {
        
          Bridge1 bridge = new Bridge1(token, owner, 500000000000000000);

         _bridges[token] = address(bridge);

         emit CreateBridge(token, block.timestamp, _bridges[token]);
       }
   }

   function __get__bridge (address token) public view returns(address) {
     return _bridges[token];
   }
         
}