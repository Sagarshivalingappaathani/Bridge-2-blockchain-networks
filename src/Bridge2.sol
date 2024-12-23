// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface ICERC20 is IERC20 {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

contract Bridge2 is Ownable {
    address public tokenMintAddress;
    mapping(address => uint256) public pendingBalance;

    event Burn(address indexed depositor, uint256 amount);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenMintAddress = _tokenAddress;
    }

    function burn(uint256 amt) public {
        ICERC20 token = ICERC20(tokenMintAddress);
        token.burn(msg.sender,amt);
        emit Burn(msg.sender, amt);
    }

    function withdraw(uint256 amt) public  {
        require(pendingBalance[msg.sender] >= amt, "Insufficient balance");
        pendingBalance[msg.sender] -= amt;
        ICERC20 token = ICERC20(tokenMintAddress);
        require(token.mint(msg.sender, amt), "Transfer failed");
    }

    function depositedOntheOtherSide(address user, uint256 amt) public onlyOwner {
        pendingBalance[user] += amt;
    }
}
