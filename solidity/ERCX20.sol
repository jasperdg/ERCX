pragma solidity ^0.4.23;

import "./StandardToken.sol";

contract ERCX20 is StandardToken{
    
    string public symbol;
    string public name;
    uint8 public decimals = 18;
    mapping(address => uint) owners;

    constructor(string _symbol, string _name, uint _supply, address _sender) public {
        symbol = _symbol;
        name = _name;
        totalSupply_ = _supply * (10 ** uint256(decimals));
        balances[_sender] = totalSupply_;
    }
}