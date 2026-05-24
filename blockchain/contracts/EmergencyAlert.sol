// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title EmergencyAlert
 * @dev Handles SOS triggers from devices with elevated priority.
 */
contract EmergencyAlert {
    
    event SOSTriggered(string indexed shadowID, int256 latitude, int256 longitude, uint256 heartRate, uint256 timestamp);

    /**
     * @dev Trigger SOS. Expected to be called by the bridge with elevated gas.
     */
    function triggerSOS(string memory _shadowID, int256 _lat, int256 _lng, uint256 _heartRate) external {
        // Validation could be added here (e.g. signature verification)
        
        emit SOSTriggered(_shadowID, _lat, _lng, _heartRate, block.timestamp);
    }
}
