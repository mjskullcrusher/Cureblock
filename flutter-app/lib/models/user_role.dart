enum UserRole {
  parent,
  operator,
  admin;

  String get label {
    switch (this) {
      case UserRole.parent:
        return 'Parent';
      case UserRole.operator:
        return 'Operator';
      case UserRole.admin:
        return 'Admin';
    }
  }
}
