// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// In order to call a function using only the data field of call, we need to encode:
// The function name
// The parameters we want to add
// Down to the binary level

contract CallAnything {
    address public s_someAddress;
    uint256 public s_amount;

    function transfer(address _someAddress, uint256 _amount) public {
        s_someAddress = _someAddress;
        s_amount = _amount;
    }

    // We can get a function selector as easy as this.
    // "transfer(address,uint256)" is our function signature
    // and our resulting function selector of "transfer(address,uint256)" is output from this function
    // one thing to note here is that there shouldn't be any spaces in "transfer(address,uint256)"
    function getSelectorOne() public pure returns (bytes4 selector) {
        selector = bytes4(keccak256(bytes("transfer(address,uint256)")));
    }

    function getDataToCallTransfer(
        address _someAddress,
        uint256 _amount
    ) public pure returns (bytes memory) {
        return abi.encodeWithSelector(getSelectorOne(), _someAddress, _amount);
    }
}
