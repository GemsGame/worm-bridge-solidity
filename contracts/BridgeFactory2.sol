// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./Bridge2.sol";
import "./TokenBase.sol";
import "./ITokenBase.sol";

contract BridgeFactory2 {
    event CreateBridge(address token, uint256 time, address bridge);
    event CreateToken(string name, string symbol, address token, uint256 time);

    address owner;

    mapping(address => address) public _bridges;
    mapping(address => address) public _tokens;

    constructor() {
        owner = msg.sender;
    }

    function __create_token(string memory name, string memory symbol, address _token) public {
        
        if(_tokens[_token] == address(0)) {

          TokenBase token = new TokenBase(name, symbol, address(this));
          _tokens[_token] = address(token);

          emit CreateToken(name, symbol, address(token), block.timestamp);

          __create_bridge(address(token));
        }
    }

    function __create_bridge(address token) internal {
        if (_bridges[token] == address(0)) {
            Bridge2 bridge = new Bridge2(owner, token);
            _bridges[token] = address(bridge);
            
            ITokenBase __token;
            __token = ITokenBase(token);

            __token.__set_bridge(_bridges[token]);

            emit CreateBridge(token, block.timestamp, _bridges[token]);
            
        }
    }

   function __get__token (address first_token) public view returns(address) {
     return _tokens[first_token];
   }
   
   function __get__bridge (address token) public view returns(address) {
     return _bridges[token];
   }
  
}
