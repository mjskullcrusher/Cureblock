enum AuditAction {
  enrolled,
  verified,
  searched,
  accessed;

  String get label {
    switch (this) {
      case AuditAction.enrolled:
        return 'Enrolled';
      case AuditAction.verified:
        return 'Verified';
      case AuditAction.searched:
        return 'Searched';
      case AuditAction.accessed:
        return 'Accessed';
    }
  }
}

class AuditLogModel {
  const AuditLogModel({
    required this.id,
    required this.timestamp,
    required this.userName,
    required this.action,
    required this.recordId,
    this.userAvatarUrl,
  });

  final String id;
  final DateTime timestamp;
  final String userName;
  final AuditAction action;
  final String recordId;
  final String? userAvatarUrl;

  AuditLogModel copyWith({
    String? id,
    DateTime? timestamp,
    String? userName,
    AuditAction? action,
    String? recordId,
    String? userAvatarUrl,
  }) {
    return AuditLogModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      userName: userName ?? this.userName,
      action: action ?? this.action,
      recordId: recordId ?? this.recordId,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
    );
  }
}

class BlockchainRecord {
  const BlockchainRecord({
    required this.transactionId,
    required this.verified,
    required this.timestamp,
    this.mismatchReason,
  });

  final String transactionId;
  final bool verified;
  final DateTime timestamp;
  final String? mismatchReason;

  BlockchainRecord copyWith({
    String? transactionId,
    bool? verified,
    DateTime? timestamp,
    String? mismatchReason,
  }) {
    return BlockchainRecord(
      transactionId: transactionId ?? this.transactionId,
      verified: verified ?? this.verified,
      timestamp: timestamp ?? this.timestamp,
      mismatchReason: mismatchReason ?? this.mismatchReason,
    );
  }
}

class BiometricCaptureRecord {
  const BiometricCaptureRecord({
    required this.label,
    required this.qualityPercent,
    required this.capturedAt,
  });

  final String label;
  final int qualityPercent;
  final DateTime capturedAt;

  BiometricCaptureRecord copyWith({
    String? label,
    int? qualityPercent,
    DateTime? capturedAt,
  }) {
    return BiometricCaptureRecord(
      label: label ?? this.label,
      qualityPercent: qualityPercent ?? this.qualityPercent,
      capturedAt: capturedAt ?? this.capturedAt,
    );
  }
}
