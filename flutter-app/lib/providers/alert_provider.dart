import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/alert_model.dart';

enum AlertListFilter {
  all,
  active,
  resolved,
}

final alertsProvider = Provider<List<AlertModel>>((ref) => MockData.alerts);

final alertFilterProvider =
    StateProvider<AlertListFilter>((ref) => AlertListFilter.all);

final filteredAlertsProvider = Provider<List<AlertModel>>((ref) {
  final alerts = ref.watch(alertsProvider);
  final filter = ref.watch(alertFilterProvider);

  return switch (filter) {
    AlertListFilter.all => alerts,
    AlertListFilter.active =>
      alerts.where((a) => a.status == AlertStatus.active).toList(),
    AlertListFilter.resolved =>
      alerts.where((a) => a.status == AlertStatus.resolved).toList(),
  };
});

final activeAlertCountProvider = Provider<int>((ref) {
  return ref
      .watch(alertsProvider)
      .where((a) => a.status == AlertStatus.active)
      .length;
});
