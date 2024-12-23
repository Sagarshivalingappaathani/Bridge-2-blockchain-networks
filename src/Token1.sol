// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract Token1 is ERC20, Ownable{
    uint256 public totalAmt;

    constructor(uint256 _intialsupply) ERC20("Token1","T") Ownable(msg.sender){
        totalAmt = _intialsupply;
    }

    function mintTo(address to, uint256 amt) public onlyOwner{
        _mint(to, amt);
    }

    function bur(address recp, uint256 amt) public onlyOwner{
        _burn(recp, amt);
    }
}
