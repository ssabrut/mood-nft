// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Encoding {
    function combineString() public pure returns (string memory) {
        return string(abi.encodePacked("ABI", "Encoding"));
    }

    // When we send a transaction, it is "compiled" down to bytecode and sent in a "data" object of the transaction.
    // That data object now governs how future transactions will interact with it.
    // For example: https://etherscan.io/tx/0x112133a0a74af775234c077c397c8b75850ceb61840b33b23ae06b753da40490

    function encodeNumber() public pure returns (bytes memory) {
        bytes memory number = abi.encode(1);
        return number;
    }

    function encodeString() public pure returns (bytes memory) {
        bytes memory someString = abi.encode("some string");
        return someString;
    }

    // encodePacked
    // This is great if you want to save space, not good for calling functions.
    // You can sort of think of it as a compressor for the massive bytes object above.
    function encodeStringPacked() public pure returns (bytes memory) {
        bytes memory someString = abi.encodePacked("some string");
        return someString;
    }

    function decodeString() public pure returns (string memory) {
        string memory someString = abi.decode(encodeString(), (string));
        return someString;
    }

    function multiEncode() public pure returns (bytes memory) {
        bytes memory someString = abi.encode("some string", "it's bigger!");
        return someString;
    }

    function multiDecode() public pure returns (string memory, string memory) {
        (string memory someString, string memory someOtherString) = abi.decode(
            multiEncode(),
            (string, string)
        );
        return (someString, someOtherString);
    }

    function multiEncodePacked() public pure returns (bytes memory) {
        bytes memory someString = abi.encodePacked(
            "some string",
            "it's bigger!"
        );
        return someString;
    }

    // This doesn't work!
    function multiDecodePacked() public pure returns (string memory) {
        string memory someString = abi.decode(multiEncodePacked(), (string));
        return someString;
    }

    // This does!
    function multiStringCastPacked() public pure returns (string memory) {
        string memory someString = string(multiEncodePacked());
        return someString;
    }

    // Remember how before I said you always need two things to call a contract:
    // 1. ABI
    // 2. Contract Address?
    // Well... That was true, but you don't need that massive ABI file. All we need to know is how to create the binary to call
    // the functions that we want to call.

    // Solidity has some more "low-level" keywords, namely "staticcall" and "call". We've used call in the past, but
    // haven't really explained what was going on. There is also "send"... but basically forget about send.

    // call: How we call functions to change the state of the blockchain.
    // staticcall: This is how (at a low level) we do our "view" or "pure" function calls, and potentially don't change the blockchain state.

    // When you call a function, you are secretly calling "call" behind the scenes, with everything compiled down to the binary stuff
    // for you. Flashback to when we withdrew ETH from our raffle:

    function withdraw(address recentWinner) public {
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        require(success, "Transfer Failed");
    }
}
