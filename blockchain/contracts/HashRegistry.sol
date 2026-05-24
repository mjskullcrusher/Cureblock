// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./AccessControlRegistry.sol";

/**
 * @title HashRegistry
 * @dev Integrity verification for off-chain data (IPFS, PostgreSQL, forensic bundles).
 */
contract HashRegistry {
    AccessControlRegistry public accessControl;

    // Mapping from a unique identifier (like CID or record ID) to its expected SHA-256 hash
    mapping(string => bytes32) public storedHashes;

    event HashStored(string indexed identifier, bytes32 dataHash);

    constructor(address _accessControlAddress) {
        accessControl = AccessControlRegistry(_accessControlAddress);
    }

    function storeHash(string memory _identifier, bytes32 _dataHash) external {
        // Typically operators or automated bridging nodes store hashes
        require(
            accessControl.hasRole(accessControl.OPERATOR_ROLE(), msg.sender) ||
            accessControl.hasRole(accessControl.AUTHORITY_ROLE(), msg.sender),
            "HashRegistry: Unauthorized"
        );
        storedHashes[_identifier] = _dataHash;
        emit HashStored(_identifier, _dataHash);
    }

    function verifyHash(string memory _identifier, bytes32 _dataHash) external view returns (bool) {
        return storedHashes[_identifier] == _dataHash;
    }
}
