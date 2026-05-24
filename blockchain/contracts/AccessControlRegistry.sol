// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title AccessControlRegistry
 * @dev Manages Role-Based Access Control (RBAC) for the Cureblock platform.
 */
contract AccessControlRegistry is AccessControl {
    bytes32 public constant PARENT_ROLE = keccak256("PARENT_ROLE");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    bytes32 public constant AUTHORITY_ROLE = keccak256("AUTHORITY_ROLE");
    bytes32 public constant RECOVERY_CENTRE_ROLE = keccak256("RECOVERY_CENTRE_ROLE");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    modifier onlyParent() {
        require(hasRole(PARENT_ROLE, msg.sender), "AccessControlRegistry: Must have PARENT_ROLE");
        _;
    }

    modifier onlyAuthority() {
        require(hasRole(AUTHORITY_ROLE, msg.sender), "AccessControlRegistry: Must have AUTHORITY_ROLE");
        _;
    }

    modifier onlyOperator() {
        require(hasRole(OPERATOR_ROLE, msg.sender), "AccessControlRegistry: Must have OPERATOR_ROLE");
        _;
    }
}
