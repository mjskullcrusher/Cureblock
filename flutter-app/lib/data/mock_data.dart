import 'package:latlong2/latlong.dart';

import '../models/alert_model.dart';
import '../models/audit_log_model.dart';
import '../models/child_model.dart';
import '../models/guardian_model.dart';
import '../models/iot_device_model.dart';

abstract final class MockData {
  static final now = DateTime.now();

  static const homeZoneCenter = LatLng(28.6139, 77.2090);

  static List<ChildModel> get children => [
        ChildModel(
          id: 'child-1',
          name: 'Aanya Sharma',
          age: 8,
          dateOfBirth: DateTime(2017, 4, 12),
          gender: Gender.female,
          status: ChildStatus.active,
          blockchainId: 'CB-0x7f3a9c2e1b4d8f6a',
          aadhaarStatus: AadhaarStatus.linked,
          biometricMilestones: const [true, true, false, false],
          guardians: _guardians,
          trustedContacts: const [
            TrustedContact(name: 'Raj Sharma', relationship: 'Father'),
            TrustedContact(name: 'Meera Sharma', relationship: 'Grandmother'),
            TrustedContact(name: 'Dr. Priya Nair', relationship: 'Pediatrician'),
          ],
          lastSeenLabel: '2 min ago',
          currentZone: 'Home zone',
          isSafe: true,
          enrolmentDate: DateTime(2020, 6, 15),
          guardianName: 'Raj Sharma',
          guardianPhone: '+91 98765 43210',
          enrolmentCenter: 'Delhi Central Centre',
          captureHistory: [
            BiometricCaptureRecord(
              label: 'Birth enrolment',
              qualityPercent: 92,
              capturedAt: DateTime(2017, 4, 20),
            ),
            BiometricCaptureRecord(
              label: '2-year milestone',
              qualityPercent: 87,
              capturedAt: DateTime(2019, 4, 18),
            ),
          ],
          blockchainRecord: BlockchainRecord(
            transactionId: 'TX-0x9a2f1c8e4b7d3a6f',
            verified: true,
            timestamp: DateTime(2024, 11, 2, 14, 30),
          ),
          iotDevice: const IoTDeviceModel(
            deviceId: 'IOT-GPS-88421',
            batteryPercent: 87,
            gpsSignalStrength: 4,
            rfidStatus: 'Active',
            lastLocation: 'Home zone, New Delhi',
            gpsDeviceName: 'CureBlock GPS Band v2',
          ),
          iotEvents: [
            IoTEvent(label: 'Entered Home zone', timestamp: now.subtract(const Duration(minutes: 2))),
            IoTEvent(label: 'Battery 87%', timestamp: now.subtract(const Duration(hours: 1))),
            IoTEvent(label: 'RFID scan at school gate', timestamp: now.subtract(const Duration(hours: 6))),
          ],
        ),
        ChildModel(
          id: 'child-2',
          name: 'Rohan Patel',
          age: 11,
          dateOfBirth: DateTime(2014, 9, 3),
          gender: Gender.male,
          status: ChildStatus.missing,
          blockchainId: 'CB-0x2c8e1f4a9b6d3e7c',
          aadhaarStatus: AadhaarStatus.linked,
          biometricMilestones: const [true, true, true, false],
          guardians: _guardians.take(2).toList(),
          trustedContacts: const [
            TrustedContact(name: 'Kavita Patel', relationship: 'Mother'),
          ],
          lastSeenLabel: '3 days ago',
          currentZone: 'Unknown',
          isSafe: false,
          enrolmentDate: DateTime(2018, 1, 10),
          guardianName: 'Kavita Patel',
          guardianPhone: '+91 91234 56789',
          enrolmentCenter: 'Mumbai West Centre',
          captureHistory: [
            BiometricCaptureRecord(
              label: '5-year milestone',
              qualityPercent: 78,
              capturedAt: DateTime(2019, 9, 5),
            ),
          ],
          blockchainRecord: BlockchainRecord(
            transactionId: 'TX-0x4d7b2e9f1a8c5e3d',
            verified: true,
            timestamp: DateTime(2024, 8, 20, 9, 15),
          ),
          iotDevice: const IoTDeviceModel(
            deviceId: 'IOT-GPS-55219',
            batteryPercent: 12,
            gpsSignalStrength: 1,
            rfidStatus: 'Inactive',
            lastLocation: 'Last ping: Andheri East',
            gpsDeviceName: 'CureBlock GPS Band v1',
          ),
          iotEvents: [
            IoTEvent(label: 'Geofence breach alert', timestamp: now.subtract(const Duration(days: 3))),
          ],
        ),
        ChildModel(
          id: 'child-3',
          name: 'Isha Reddy',
          age: 6,
          dateOfBirth: DateTime(2019, 12, 22),
          gender: Gender.female,
          status: ChildStatus.rescued,
          blockchainId: 'CB-0x5e9d2a7f3c1b8e4d',
          aadhaarStatus: AadhaarStatus.pending,
          biometricMilestones: const [true, false, false, false],
          guardians: _guardians,
          trustedContacts: const [
            TrustedContact(name: 'Arjun Reddy', relationship: 'Father'),
          ],
          lastSeenLabel: '1 hour ago',
          currentZone: 'Rescue centre',
          isSafe: true,
          enrolmentDate: DateTime(2022, 3, 8),
          guardianName: 'Arjun Reddy',
          guardianPhone: '+91 99887 76655',
          enrolmentCenter: 'Hyderabad South Centre',
          captureHistory: [
            BiometricCaptureRecord(
              label: 'Birth enrolment',
              qualityPercent: 95,
              capturedAt: DateTime(2020, 1, 5),
            ),
          ],
          blockchainRecord: BlockchainRecord(
            transactionId: 'TX-0x1f8e3c7a2b9d4e6f',
            verified: true,
            timestamp: DateTime(2025, 1, 14, 16, 45),
          ),
          iotDevice: const IoTDeviceModel(
            deviceId: 'IOT-GPS-33107',
            batteryPercent: 64,
            gpsSignalStrength: 3,
            rfidStatus: 'Active',
            lastLocation: 'Rescue Centre, Hyderabad',
            gpsDeviceName: 'CureBlock GPS Band v2',
          ),
          iotEvents: [
            IoTEvent(label: 'Rescue match confirmed', timestamp: now.subtract(const Duration(hours: 1))),
          ],
        ),
      ];

  static final List<GuardianModel> _guardians = [
    const GuardianModel(
      id: 'guardian-1',
      name: 'Raj Sharma',
      relationship: 'Father',
      accessLevel: GuardianAccessLevel.full,
    ),
    const GuardianModel(
      id: 'guardian-2',
      name: 'Sunita Sharma',
      relationship: 'Mother',
      accessLevel: GuardianAccessLevel.full,
    ),
    const GuardianModel(
      id: 'guardian-3',
      name: 'Meera Sharma',
      relationship: 'Grandmother',
      accessLevel: GuardianAccessLevel.viewOnly,
    ),
  ];

  static List<AlertModel> get alerts => [
        AlertModel(
          id: 'alert-1',
          title: 'Geofence breach',
          description: 'Aanya left the Home zone boundary.',
          timestamp: now.subtract(const Duration(hours: 2)),
          type: AlertType.geofenceBreach,
          status: AlertStatus.resolved,
          childId: 'child-1',
        ),
        AlertModel(
          id: 'alert-2',
          title: 'Low battery warning',
          description: 'GPS band battery below 20%.',
          timestamp: now.subtract(const Duration(days: 1)),
          type: AlertType.deviceWarning,
          status: AlertStatus.active,
          childId: 'child-2',
        ),
        AlertModel(
          id: 'alert-3',
          title: 'Device offline',
          description: 'No signal from Rohan\'s GPS band for 24h.',
          timestamp: now.subtract(const Duration(days: 2)),
          type: AlertType.deviceWarning,
          status: AlertStatus.active,
          childId: 'child-2',
        ),
        AlertModel(
          id: 'alert-4',
          title: 'Safe zone entry',
          description: 'Aanya entered Home zone.',
          timestamp: now.subtract(const Duration(minutes: 30)),
          type: AlertType.resolved,
          status: AlertStatus.resolved,
          childId: 'child-1',
        ),
      ];

  static List<AuditLogModel> get auditLogs => [
        AuditLogModel(
          id: 'audit-1',
          timestamp: now.subtract(const Duration(minutes: 15)),
          userName: 'Priya Operator',
          action: AuditAction.enrolled,
          recordId: 'CB-REC-88421',
        ),
        AuditLogModel(
          id: 'audit-2',
          timestamp: now.subtract(const Duration(hours: 2)),
          userName: 'Admin User',
          action: AuditAction.accessed,
          recordId: 'CB-REC-55219',
        ),
        AuditLogModel(
          id: 'audit-3',
          timestamp: now.subtract(const Duration(hours: 5)),
          userName: 'Ravi Operator',
          action: AuditAction.searched,
          recordId: 'CB-REC-33107',
        ),
        AuditLogModel(
          id: 'audit-4',
          timestamp: now.subtract(const Duration(days: 1)),
          userName: 'Priya Operator',
          action: AuditAction.verified,
          recordId: 'CB-REC-88421',
        ),
        AuditLogModel(
          id: 'audit-5',
          timestamp: now.subtract(const Duration(days: 2)),
          userName: 'Admin User',
          action: AuditAction.enrolled,
          recordId: 'CB-REC-99102',
        ),
      ];

  static List<Map<String, dynamic>> get operatorRecentActivity => [
        {
          'label': 'Enrolled Aanya Sharma',
          'timestamp': now.subtract(const Duration(minutes: 45)),
        },
        {
          'label': 'Verified biometric for Isha Reddy',
          'timestamp': now.subtract(const Duration(hours: 3)),
        },
        {
          'label': 'Search: missing children in Mumbai',
          'timestamp': now.subtract(const Duration(hours: 6)),
        },
        {
          'label': 'Rescue match: Rohan Patel',
          'timestamp': now.subtract(const Duration(days: 1)),
        },
        {
          'label': 'Linked Aadhaar for child CB-88421',
          'timestamp': now.subtract(const Duration(days: 2)),
        },
      ];

  static List<double> get adminEnrolmentTrend => const [
        4, 6, 5, 8, 7, 9, 11, 10, 12, 14, 13, 15,
        16, 14, 18, 17, 19, 21, 20, 22, 24, 23, 25, 27,
        26, 28, 30, 29, 31, 33,
      ];

  static List<BlockchainIntegrityRecord> get blockchainIntegrityRecords => [
        const BlockchainIntegrityRecord(
          childName: 'Aanya Sharma',
          recordId: 'CB-REC-88421',
          verified: true,
        ),
        const BlockchainIntegrityRecord(
          childName: 'Rohan Patel',
          recordId: 'CB-REC-55219',
          verified: false,
          mismatchDetail: 'Hash mismatch on biometric block 3',
        ),
        const BlockchainIntegrityRecord(
          childName: 'Isha Reddy',
          recordId: 'CB-REC-33107',
          verified: true,
        ),
      ];

  static List<BiometricMatchCandidate> get rescueMatchCandidates => [
        const BiometricMatchCandidate(
          childId: 'child-3',
          name: 'Isha Reddy',
          age: 6,
          dateOfBirth: '22 Dec 2019',
          score: 0.96,
        ),
        const BiometricMatchCandidate(
          childId: 'child-1',
          name: 'Aanya Sharma',
          age: 8,
          dateOfBirth: '12 Apr 2017',
          score: 0.78,
        ),
        const BiometricMatchCandidate(
          childId: 'child-2',
          name: 'Rohan Patel',
          age: 11,
          dateOfBirth: '03 Sep 2014',
          score: 0.52,
        ),
      ];
}

class BlockchainIntegrityRecord {
  const BlockchainIntegrityRecord({
    required this.childName,
    required this.recordId,
    required this.verified,
    this.mismatchDetail,
  });

  final String childName;
  final String recordId;
  final bool verified;
  final String? mismatchDetail;
}

class BiometricMatchCandidate {
  const BiometricMatchCandidate({
    required this.childId,
    required this.name,
    required this.age,
    required this.dateOfBirth,
    required this.score,
  });

  final String childId;
  final String name;
  final int age;
  final String dateOfBirth;
  final double score;
}
