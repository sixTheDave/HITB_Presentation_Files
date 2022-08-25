// SPDX-License-Identifier: Unlicense

// Two contracts in one file

pragma solidity >=0.8.0 <0.9.0;

contract One {
    Two public twoContract;

    function setTwoContract(address _twoAddress) public returns (bool){
        twoContract = Two(_twoAddress);
        return true;
    }

    function setValueOnTwo() public returns (bool) {
        twoContract.setValue(1);
        return true;
    }
}

contract Two {
    uint256 public myInt;

    function setValue(uint256 _int) public returns (bool){
        myInt = _int;
        return true;
    }
}
