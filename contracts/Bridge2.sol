// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
import "./ITokenBase.sol";

contract Bridge2 {
    address public owner;
    uint public fee;
    ITokenBase public token;

    constructor(address _owner, address _child_token, uint _fee) payable {
        owner = _owner;
        token = ITokenBase(_child_token);
        fee = _fee;
    }
    

    mapping(string => bool) public __mint;

    event TokenMint(address to, uint amount, uint timestamp);
    event TokensBurn(address from, uint amount, uint timestamp);

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
        uint amount
    ) external {

        token.transferFrom(msg.sender, address(this), amount);

        token.burn(address(this), amount);

        emit TokensBurn(msg.sender, amount, block.timestamp);
    }



    function __mint_txhash (string memory txhash ) public view returns(bool) {
      return __mint[txhash];
    }
    
    function __set_fee (uint _fee) external {
        require(
            msg.sender == owner,
            "you are not an owner"
        );

        fee = _fee;
    }

}
