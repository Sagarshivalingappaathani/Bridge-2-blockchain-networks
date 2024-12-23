// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Bridge1 is Ownable {
    address public tokenMintAddress;
    mapping(address => uint256) public pendingBalance;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdraw(address indexed withdrawer, uint256 amount);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenMintAddress = _tokenAddress;
    }

    function deposit(uint256 amt) public {
        IERC20 token = IERC20(tokenMintAddress);
        require(token.allowance(msg.sender, address(this)) >= amt, "Insufficient allowance");
        require(token.transferFrom(msg.sender, address(this), amt), "Transfer failed");
        emit Deposit(msg.sender, amt);
    }

    function withdraw(uint256 amt) public  {
        require(pendingBalance[msg.sender] >= amt, "Insufficient balance");
        pendingBalance[msg.sender] -= amt;
        IERC20 token = IERC20(tokenMintAddress);
        require(token.transfer(msg.sender, amt), "Transfer failed");
        emit Withdraw(msg.sender, amt);
    }

    function burnedOntheOtherSide(address user, uint256 amt) public onlyOwner {
        pendingBalance[user] += amt;
    }
}
