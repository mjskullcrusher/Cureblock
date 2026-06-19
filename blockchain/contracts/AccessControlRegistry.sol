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

    mapping(address => uint256) public authorityExpiry;

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

    /**
     * @dev Grants the AUTHORITY_ROLE to an account with a strict 24-hour expiration.
     * Can only be called by a DEFAULT_ADMIN_ROLE.
     */
    function grantAuthority(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        authorityExpiry[account] = block.timestamp + 24 hours;
        _grantRole(AUTHORITY_ROLE, account);
    }

    /**
     * @dev Overrides standard hasRole to enforce 24-hour auto-expiration for AUTHORITY_ROLE.
     */
    function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
        if (role == AUTHORITY_ROLE) {
            return super.hasRole(role, account) && block.timestamp <= authorityExpiry[account];
        }
        return super.hasRole(role, account);
    }
}
