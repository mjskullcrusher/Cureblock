import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_role.dart';

final roleProvider = StateProvider<UserRole>((ref) => UserRole.parent);

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

final currentUserNameProvider = StateProvider<String>((ref) {
  final role = ref.watch(roleProvider);
  return switch (role) {
    UserRole.parent => 'Raj Sharma',
    UserRole.operator => 'Priya Operator',
    UserRole.admin => 'Admin User',
  };
});

void signIn(WidgetRef ref, {UserRole? role}) {
  if (role != null) {
    ref.read(roleProvider.notifier).state = role;
  }
  ref.read(isAuthenticatedProvider.notifier).state = true;
}

void signOut(WidgetRef ref) {
  ref.read(isAuthenticatedProvider.notifier).state = false;
}
