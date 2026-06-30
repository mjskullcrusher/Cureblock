import 'audit_log_model.dart';
import 'guardian_model.dart';
import 'iot_device_model.dart';

enum ChildStatus {
  active,
  missing,
  rescued,
  alert;

  String get label {
    switch (this) {
      case ChildStatus.active:
        return 'active';
      case ChildStatus.missing:
        return 'missing';
      case ChildStatus.rescued:
        return 'rescued';
      case ChildStatus.alert:
        return 'alert';
    }
  }
}

enum AadhaarStatus {
  linked,
  pending;

  String get label {
    switch (this) {
      case AadhaarStatus.linked:
        return 'Linked';
      case AadhaarStatus.pending:
        return 'Pending';
    }
  }
}

enum Gender {
  male,
  female,
  other;

  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

class ChildModel {
  const ChildModel({
    required this.id,
    required this.name,
    required this.age,
    required this.dateOfBirth,
    required this.gender,
    required this.status,
    required this.blockchainId,
    required this.aadhaarStatus,
    required this.biometricMilestones,
    required this.guardians,
    required this.trustedContacts,
    required this.lastSeenLabel,
    required this.currentZone,
    required this.isSafe,
    required this.enrolmentDate,
    required this.guardianName,
    required this.guardianPhone,
    required this.enrolmentCenter,
    required this.captureHistory,
    required this.blockchainRecord,
    required this.iotDevice,
    required this.iotEvents,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final int age;
  final DateTime dateOfBirth;
  final Gender gender;
  final ChildStatus status;
  final String? avatarUrl;
  final String blockchainId;
  final AadhaarStatus aadhaarStatus;
  /// Four milestones: Birth, 2yr, 5yr, 15yr — `true` = completed.
  final List<bool> biometricMilestones;
  final List<GuardianModel> guardians;
  final List<TrustedContact> trustedContacts;
  final String lastSeenLabel;
  final String currentZone;
  final bool isSafe;
  final DateTime enrolmentDate;
  final String guardianName;
  final String guardianPhone;
  final String enrolmentCenter;
  final List<BiometricCaptureRecord> captureHistory;
  final BlockchainRecord blockchainRecord;
  final IoTDeviceModel iotDevice;
  final List<IoTEvent> iotEvents;

  ChildModel copyWith({
    String? id,
    String? name,
    int? age,
    DateTime? dateOfBirth,
    Gender? gender,
    ChildStatus? status,
    String? avatarUrl,
    String? blockchainId,
    AadhaarStatus? aadhaarStatus,
    List<bool>? biometricMilestones,
    List<GuardianModel>? guardians,
    List<TrustedContact>? trustedContacts,
    String? lastSeenLabel,
    String? currentZone,
    bool? isSafe,
    DateTime? enrolmentDate,
    String? guardianName,
    String? guardianPhone,
    String? enrolmentCenter,
    List<BiometricCaptureRecord>? captureHistory,
    BlockchainRecord? blockchainRecord,
    IoTDeviceModel? iotDevice,
    List<IoTEvent>? iotEvents,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      blockchainId: blockchainId ?? this.blockchainId,
      aadhaarStatus: aadhaarStatus ?? this.aadhaarStatus,
      biometricMilestones: biometricMilestones ?? this.biometricMilestones,
      guardians: guardians ?? this.guardians,
      trustedContacts: trustedContacts ?? this.trustedContacts,
      lastSeenLabel: lastSeenLabel ?? this.lastSeenLabel,
      currentZone: currentZone ?? this.currentZone,
      isSafe: isSafe ?? this.isSafe,
      enrolmentDate: enrolmentDate ?? this.enrolmentDate,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      enrolmentCenter: enrolmentCenter ?? this.enrolmentCenter,
      captureHistory: captureHistory ?? this.captureHistory,
      blockchainRecord: blockchainRecord ?? this.blockchainRecord,
      iotDevice: iotDevice ?? this.iotDevice,
      iotEvents: iotEvents ?? this.iotEvents,
    );
  }
}
