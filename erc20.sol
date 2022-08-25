// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;

contract HITB_Token {
    string public constant name     = "HITB Token";
    string public constant symbol   = "HITB";
    uint8  public constant decimals = 0;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 private totalSupply_ = 1000000;

    address public admin;
    bool public _paused;

    constructor() {
        admin = msg.sender;
        balances[msg.sender] = totalSupply_;
    }

    function pause() external returns (bool success) {
        require(msg.sender == admin, "Not authorized");
        _paused = true;
        return _paused;
    }

    function unpause() external returns (bool success) {
        require(msg.sender == admin, "Not authorized");
        _paused = false;
        return _paused;
    }

    function adminChange(address newAdmin) external returns (address to) {
        require(msg.sender == admin, "Not authorized");
        admin = newAdmin;
        return newAdmin;
    }


    function totalSupply() external view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address _owner) external view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(_paused == false);
        require(_value <= balances[msg.sender]);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require(_paused == false);
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);


        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) external view returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    function adminWithdraw() external returns (bool success) {
        require(msg.sender == admin, "Not authorized");
        payable(msg.sender).transfer(address(this).balance);
        return true;
    }

    fallback() external payable {}
    receive() external payable {}
}
