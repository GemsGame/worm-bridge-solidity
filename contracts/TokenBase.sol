// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract TokenBase is ERC20 {

  address bridge;
  address factory;

  constructor(string memory name, string memory symbol, address _factory) ERC20(name, symbol) {
    factory = _factory;
  }
  
  event TokensBurn(address owner, uint amount, uint timestamp);


  modifier defender {
    if (msg.sender != factory && msg.sender != bridge) {
      _;
    }
  }

  function __set_bridge (address _bridge) external defender {
     bridge = _bridge;
  }

  function mint(address to, uint amount) external defender{
    _mint(to, amount);
  }

  function burn(uint amount) external { 
    _burn(msg.sender, amount);

    emit TokensBurn(msg.sender, amount, block.timestamp);
  }
}