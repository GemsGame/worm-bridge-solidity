// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bridge1 {
    
    address public token;
    address public owner;
    uint public fee;

    constructor (address _token, address _owner, uint _fee) payable {
        token = _token;
        owner = _owner;
        fee = _fee;
    }

    mapping(string => bool) public __unlock;

    event LockTokens(address from, address to, address token, uint amount, uint fee, uint time);
    event UnlockTokens(address from, address to, address token, uint amount, uint fee, uint time);
    


    function lock (uint amount) external {

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        
        emit LockTokens(msg.sender, address(this), token, amount, fee, block.timestamp);
    
    }
   

   function unlock (address to, uint amount, string memory txhash) external {
         
        require(
            __unlock[txhash] == false,
            "unlock already processed"
        );
        
        require(
            msg.sender == owner,
            "you are not an owner"
        );
        
       IERC20(token).transfer(to, amount);

       __unlock[txhash] = true;

       emit UnlockTokens(address(this), to, token, amount, fee, block.timestamp);

   }


    
   function __set_fee (uint _fee) external {
        require(
            msg.sender == owner,
            "you are not an owner"
        );

        fee = _fee;
   }
     
}