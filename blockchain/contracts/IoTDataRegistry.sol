// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./AccessControlRegistry.sol";

/**
 * @title IoTDataRegistry
 * @dev Anchors Merkle roots of 5-minute IoT telemetry batches for efficient on-chain storage.
 */
contract IoTDataRegistry {
    AccessControlRegistry public accessControl;

    struct Batch {
        bytes32 merkleRoot;
        uint256 timestamp;
        string deviceId; // e.g., Shadow ID or MAC
    }

    mapping(string => Batch[]) public deviceBatches;

    event MerkleRootAnchored(string indexed deviceId, bytes32 merkleRoot, uint256 timestamp);

    constructor(address _accessControlAddress) {
        accessControl = AccessControlRegistry(_accessControlAddress);
    }

    function anchorMerkleRoot(string memory _deviceId, bytes32 _merkleRoot) external {
        require(accessControl.hasRole(accessControl.OPERATOR_ROLE(), msg.sender), "IoTDataRegistry: Unauthorized");
        
        deviceBatches[_deviceId].push(Batch({
            merkleRoot: _merkleRoot,
            timestamp: block.timestamp,
            deviceId: _deviceId
        }));

        emit MerkleRootAnchored(_deviceId, _merkleRoot, block.timestamp);
    }
}
