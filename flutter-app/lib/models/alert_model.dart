enum AlertType {
  geofenceBreach,
  deviceWarning,
  resolved,
}

enum AlertStatus {
  active,
  resolved,
}

class AlertModel {
  const AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.childId,
  });

  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final AlertType type;
  final AlertStatus status;
  final String childId;

  AlertModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? timestamp,
    AlertType? type,
    AlertStatus? status,
    String? childId,
  }) {
    return AlertModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      childId: childId ?? this.childId,
    );
  }
}
