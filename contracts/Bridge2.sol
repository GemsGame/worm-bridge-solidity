// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
import "./ITokenBase.sol";

contract Bridge2 {
    address public owner;
    ITokenBase public token;

    constructor(address _owner, address _child_token) {
        owner = _owner;
        token = ITokenBase(_child_token);
    }

    mapping(string => bool) public __mint;
    mapping(string => bool) public __burn;

    event TokenMint(address to, uint amount, uint timestamp);
    event TokensBurn(address owner, uint amount, uint timestamp);

    function mint(
        address to,
        uint amount,
        string memory txhash
    ) external {
      
        require(
            __mint[txhash] == false,
            "transfer already processed"
        );

        require(
            msg.sender == owner,
            "you are not an owner"
        );

        __mint[txhash] = true;

        token.mint(to, amount);

        emit TokenMint(
            to,
            amount,
            block.timestamp
        );
    }

    function burn(
        uint amount,
        string memory txhash
    ) external {
      
        require(
            __burn[txhash] == false,
            "burn already processed"
        );

        require(
            msg.sender == owner,
            "you are not an owner"
        );

        __burn[txhash] = true;

        token.burn(address(this), amount);

        emit TokensBurn(address(this), amount, block.timestamp);
    }


    function __mint_txhash (string memory txhash ) public view returns(bool) {
      return __mint[txhash];
    }
    
    function __burn_txhash (string memory txhash ) public view returns(bool) {
      return __burn[txhash];
    }

}
