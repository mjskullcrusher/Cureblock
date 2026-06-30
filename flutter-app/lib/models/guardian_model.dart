enum GuardianAccessLevel {
  full,
  viewOnly;

  String get label {
    switch (this) {
      case GuardianAccessLevel.full:
        return 'Full';
      case GuardianAccessLevel.viewOnly:
        return 'View only';
    }
  }
}

class GuardianModel {
  const GuardianModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.accessLevel,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String relationship;
  final GuardianAccessLevel accessLevel;
  final String? avatarUrl;

  GuardianModel copyWith({
    String? id,
    String? name,
    String? relationship,
    GuardianAccessLevel? accessLevel,
    String? avatarUrl,
  }) {
    return GuardianModel(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      accessLevel: accessLevel ?? this.accessLevel,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class TrustedContact {
  const TrustedContact({
    required this.name,
    required this.relationship,
    this.avatarUrl,
  });

  final String name;
  final String relationship;
  final String? avatarUrl;

  TrustedContact copyWith({
    String? name,
    String? relationship,
    String? avatarUrl,
  }) {
    return TrustedContact(
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
