class IoTDeviceModel {
  const IoTDeviceModel({
    required this.deviceId,
    required this.batteryPercent,
    required this.gpsSignalStrength,
    required this.rfidStatus,
    required this.lastLocation,
    this.gpsDeviceName,
  });

  final String deviceId;
  final int batteryPercent;
  /// Signal strength from 0 (none) to 4 (excellent).
  final int gpsSignalStrength;
  final String rfidStatus;
  final String lastLocation;
  final String? gpsDeviceName;

  IoTDeviceModel copyWith({
    String? deviceId,
    int? batteryPercent,
    int? gpsSignalStrength,
    String? rfidStatus,
    String? lastLocation,
    String? gpsDeviceName,
  }) {
    return IoTDeviceModel(
      deviceId: deviceId ?? this.deviceId,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      gpsSignalStrength: gpsSignalStrength ?? this.gpsSignalStrength,
      rfidStatus: rfidStatus ?? this.rfidStatus,
      lastLocation: lastLocation ?? this.lastLocation,
      gpsDeviceName: gpsDeviceName ?? this.gpsDeviceName,
    );
  }
}

class IoTEvent {
  const IoTEvent({
    required this.label,
    required this.timestamp,
  });

  final String label;
  final DateTime timestamp;

  IoTEvent copyWith({
    String? label,
    DateTime? timestamp,
  }) {
    return IoTEvent(
      label: label ?? this.label,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
