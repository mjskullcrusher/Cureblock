// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ShadowNode
 * @dev Privacy-preserving identity layer generating Shadow IDs using block hash entropy.
 */
contract ShadowNode {
    // Mapping from DID to Shadow ID
    mapping(string => bytes32) private shadowIDs;

    event ShadowIDGenerated(string did, bytes32 shadowID);

    /**
     * @dev Generates a pseudo-random Shadow ID based on block difficulty and timestamp.
     * Note: block.prevrandao replaces block.difficulty in >= 0.8.18 (post-Merge).
     */
    function generateShadowID(string memory _did) external returns (bytes32) {
        require(shadowIDs[_did] == bytes32(0), "ShadowNode: Shadow ID already exists for this DID");
        
        bytes32 newShadowID = keccak256(abi.encodePacked(_did, block.timestamp, block.prevrandao));
        shadowIDs[_did] = newShadowID;

        emit ShadowIDGenerated(_did, newShadowID);
        return newShadowID;
    }

    function getShadowID(string memory _did) external view returns (bytes32) {
        return shadowIDs[_did];
    }
}
