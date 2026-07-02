// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./AccessControlRegistry.sol";

/**
 * @title IdentityRegistry
 * @dev Central registry for child identities, storing biometric hashes and metadata.
 */
contract IdentityRegistry {
    AccessControlRegistry public accessControl;

    struct ChildIdentity {
        string did;
        bytes32 fingerprintHash;
        bytes32 leftIrisHash;
        bytes32 rightIrisHash;
        address parentWallet;
        string ipfsCID;
        string biometricImageCID;
        bool isActive;
    }

    // Mapping from DID to ChildIdentity
    mapping(string => ChildIdentity) public identities;

    event IdentityRegistered(string did, address indexed parentWallet);

    constructor(address _accessControlAddress) {
        accessControl = AccessControlRegistry(_accessControlAddress);
    }

    function registerIdentity(
        string memory _did,
        bytes32 _fingerprintHash,
        bytes32 _leftIrisHash,
        bytes32 _rightIrisHash,
        address _parentWallet,
        string memory _ipfsCID,
        string memory _biometricImageCID
    ) external {
        require(accessControl.hasRole(accessControl.OPERATOR_ROLE(), msg.sender), "IdentityRegistry: Must have OPERATOR_ROLE");
        require(!identities[_did].isActive, "IdentityRegistry: Identity already exists");

        identities[_did] = ChildIdentity({
            did: _did,
            fingerprintHash: _fingerprintHash,
            leftIrisHash: _leftIrisHash,
            rightIrisHash: _rightIrisHash,
            parentWallet: _parentWallet,
            ipfsCID: _ipfsCID,
            biometricImageCID: _biometricImageCID,
            isActive: true
        });

        emit IdentityRegistered(_did, _parentWallet);
    }

    // Additional functions for device pairing and retrieving data would go here
}
