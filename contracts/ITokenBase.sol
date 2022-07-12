// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface ITokenBase {
  function mint(address to, uint amount) external;
  function __set_bridge(address _bridge) external;
}