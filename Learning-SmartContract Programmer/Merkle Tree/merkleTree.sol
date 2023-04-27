//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract merkleProof {
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf,
        uint index
    ) public pure returns (bool) {
        bytes32 hash = leaf;

        //recomputing the merkle root from the given hashes

        for (uint i = 0; i < proof.length; i++) {
            if (index % 2 == 0) {
                hash = keccak256(abi.encode(leaf, proof[i]));
            } else {
                hash = keccak256(abi.encode(proof[i], leaf));
            }
            index = index / 2;
        }

        return hash == root;
    }
}

contract merkleTest {}
