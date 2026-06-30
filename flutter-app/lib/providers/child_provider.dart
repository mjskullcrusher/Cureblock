import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/child_model.dart';
import '../models/guardian_model.dart';
import '../models/child_list_item.dart';
import '../models/child_detail.dart';
import '../services/child_api_service.dart';

// ---------- API-backed providers (real backend data) ----------

final childApiServiceProvider = Provider((ref) => ChildApiService());

final childrenFromApiProvider = FutureProvider<List<ChildListItem>>((ref) async {
 final api = ref.watch(childApiServiceProvider);
 return api.getChildren();
});

final childDetailProvider =
 FutureProvider.family<ChildDetail, String>((ref, id) async {
 final api = ref.watch(childApiServiceProvider);
 return api.getChild(id);
});

// ---------- Existing mock-backed providers (still used by other screens) ----------

final childrenProvider = Provider<List<ChildModel>>((ref) => MockData.children);

final selectedChildIdProvider = StateProvider<String>((ref) => 'child-1');

final selectedChildProvider = Provider<ChildModel>((ref) {
 final id = ref.watch(selectedChildIdProvider);
 return ref.watch(childrenProvider).firstWhere((c) => c.id == id);
});

final childByIdProvider = Provider.family<ChildModel?, String>((ref, id) {
 try {
 return ref.watch(childrenProvider).firstWhere((c) => c.id == id);
 } catch (_) {
 return null;
 }
});

final guardiansProvider = Provider<List<GuardianModel>>((ref) {
 return ref.watch(selectedChildProvider).guardians;
});

final auditLogsProvider = Provider((ref) => MockData.auditLogs);

final operatorStatsProvider = Provider<OperatorStats>((ref) {
 return const OperatorStats(
 todaysEnrolments: 12,
 pendingVerifications: 5,
 rescueMatches: 2,
 );
});

final operatorRecentActivityProvider = Provider<List<ActivityEntry>>((ref) {
 return MockData.operatorRecentActivity
 .map(
 (e) => ActivityEntry(
 label: e['label'] as String,
 timestamp: e['timestamp'] as DateTime,
 ),
 )
 .toList();
});

final adminStatsProvider = Provider<AdminStats>((ref) {
 final children = ref.watch(childrenProvider);
 return AdminStats(
 totalEnrolled: 1248,
 active: children.where((c) => c.status == ChildStatus.active).length + 800,
 missing: children.where((c) => c.status == ChildStatus.missing).length + 12,
 rescued: children.where((c) => c.status == ChildStatus.rescued).length + 34,
 enrolmentTrend: MockData.adminEnrolmentTrend,
 );
});

final blockchainIntegrityProvider =
 Provider((ref) => MockData.blockchainIntegrityRecords);

final rescueMatchCandidatesProvider =
 Provider((ref) => MockData.rescueMatchCandidates);

class OperatorStats {
 const OperatorStats({
 required this.todaysEnrolments,
 required this.pendingVerifications,
 required this.rescueMatches,
 });

 final int todaysEnrolments;
 final int pendingVerifications;
 final int rescueMatches;
}

class AdminStats {
 const AdminStats({
 required this.totalEnrolled,
 required this.active,
 required this.missing,
 required this.rescued,
 required this.enrolmentTrend,
 });

 final int totalEnrolled;
 final int active;
 final int missing;
 final int rescued;
 final List<double> enrolmentTrend;
}

class ActivityEntry {
 const ActivityEntry({
 required this.label,
 required this.timestamp,
 });

 final String label;
 final DateTime timestamp;
}