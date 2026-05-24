// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./AccessControlRegistry.sol";

/**
 * @title ForensicBlackBox
 * @dev Creates court-admissible forensic evidence bundles.
 */
contract ForensicBlackBox {
    AccessControlRegistry public accessControl;

    struct EvidenceBundle {
        string ipfsCID;
        bytes32 dataMerkleRoot;
        uint256 timestamp;
    }

    // Mapping from Shadow ID to Evidence Bundles
    mapping(string => EvidenceBundle[]) public bundles;

    event BundleStored(string indexed shadowID, string ipfsCID, bytes32 dataMerkleRoot);

    constructor(address _accessControlAddress) {
        accessControl = AccessControlRegistry(_accessControlAddress);
    }

    function storeEvidenceBundle(string memory _shadowID, string memory _ipfsCID, bytes32 _dataMerkleRoot) external {
        require(accessControl.hasRole(accessControl.AUTHORITY_ROLE(), msg.sender) || 
                accessControl.hasRole(accessControl.OPERATOR_ROLE(), msg.sender), "ForensicBlackBox: Unauthorized");

        bundles[_shadowID].push(EvidenceBundle({
            ipfsCID: _ipfsCID,
            dataMerkleRoot: _dataMerkleRoot,
            timestamp: block.timestamp
        }));

        emit BundleStored(_shadowID, _ipfsCID, _dataMerkleRoot);
    }
}
