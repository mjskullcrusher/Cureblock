import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/user_role.dart';
import '../providers/auth_provider.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/audit_log_screen.dart';
import '../screens/admin/blockchain_integrity_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/login_screen.dart';
import '../screens/operator/biometric_identification_screen.dart';
import '../screens/operator/child_record_detail_screen.dart';
import '../screens/operator/child_search_screen.dart';
import '../screens/operator/enrolment_stepper_screen.dart';
import '../screens/operator/operator_dashboard_screen.dart';
import '../screens/parent/child_profile_screen.dart';
import '../screens/parent/guardian_management_screen.dart';
import '../screens/parent/parent_alerts_screen.dart';
import '../screens/parent/parent_home_screen.dart';
import '../screens/parent/parent_map_screen.dart';
import '../screens/parent/sos_screen.dart';
import '../screens/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final isAuth = ref.read(isAuthenticatedProvider);
      final role = ref.read(roleProvider);
      final path = state.uri.path;

      const publicPaths = ['/splash', '/login', '/forgot-password'];
      if (!isAuth) {
        if (publicPaths.contains(path)) return null;
        return '/login';
      }

      if (path == '/login' || path == '/splash') {
        return _homeForRole(role);
      }

      if (path.startsWith('/parent') && role != UserRole.parent) {
        return _homeForRole(role);
      }
      if (path.startsWith('/operator') && role != UserRole.operator) {
        return _homeForRole(role);
      }
      if (path.startsWith('/admin') && role != UserRole.admin) {
        return _homeForRole(role);
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/parent/home',
        builder: (context, state) => const ParentHomeScreen(),
      ),
      GoRoute(
        path: '/parent/map',
        builder: (context, state) => const ParentMapScreen(),
      ),
      GoRoute(
        path: '/parent/alerts',
        builder: (context, state) => const ParentAlertsScreen(),
      ),
      GoRoute(
        path: '/parent/sos',
        builder: (context, state) => const SosScreen(),
      ),
      GoRoute(
        path: '/parent/child/:childId',
        builder: (context, state) => ChildProfileScreen(
          childId: state.pathParameters['childId']!,
        ),
      ),
      GoRoute(
        path: '/parent/guardians',
        builder: (context, state) => const GuardianManagementScreen(),
      ),
      GoRoute(
        path: '/operator/home',
        builder: (context, state) => const OperatorDashboardScreen(),
      ),
      GoRoute(
        path: '/operator/enrolment',
        name: 'operator-enrolment',
        builder: (context, state) => const EnrolmentStepperScreen(),
      ),
      GoRoute(
        path: '/operator/search',
        builder: (context, state) => const ChildSearchScreen(),
      ),
      GoRoute(
        path: '/operator/child/:childId',
        builder: (context, state) => ChildRecordDetailScreen(
          childId: state.pathParameters['childId']!,
        ),
      ),
      GoRoute(
        path: '/operator/identify',
        builder: (context, state) => const BiometricIdentificationScreen(),
      ),
      GoRoute(
        path: '/admin/home',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/audit',
        builder: (context, state) => const AuditLogScreen(),
      ),
      GoRoute(
        path: '/admin/blockchain',
        builder: (context, state) => const BlockchainIntegrityScreen(),
      ),
    ],
  );
});

String _homeForRole(UserRole role) {
  return switch (role) {
    UserRole.parent => '/parent/home',
    UserRole.operator => '/operator/home',
    UserRole.admin => '/admin/home',
  };
}

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(isAuthenticatedProvider, (_, __) => notifyListeners());
    ref.listen(roleProvider, (_, __) => notifyListeners());
  }
}
