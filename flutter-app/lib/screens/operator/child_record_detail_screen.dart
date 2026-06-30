import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/child_provider.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/status_badge.dart';

class ChildRecordDetailScreen extends ConsumerWidget {
 const ChildRecordDetailScreen({super.key, required this.childId});

 final String childId;

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 final asyncChild = ref.watch(childDetailProvider(childId));

 return asyncChild.when(
 loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
 error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
 data: (child) => DefaultTabController(
 length: 4,
 child: Scaffold(
 appBar: AppBar(
 title: Row(
 children: [
 CircleAvatar(child: Text(child.name.isNotEmpty ? child.name[0] : '?')),
 const SizedBox(width: 12),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(child.name, style: const TextStyle(fontSize: 18)),
 StatusBadge(status: child.status),
 ],
 ),
 ),
 ],
 ),
 bottom: const TabBar(
 tabs: [
 Tab(text: 'Overview'),
 Tab(text: 'Biometrics'),
 Tab(text: 'Blockchain'),
 Tab(text: 'IoT'),
 ],
 ),
 ),
 body: TabBarView(
 children: [
 // OVERVIEW
 ListView(
 padding: const EdgeInsets.all(16),
 children: [
 _tile('Name', child.name),
 _tile('Age', '${child.age}'),
 _tile('Gender', child.gender),
 _tile('Subject ID', child.externalSubjectId ?? '-'),
 _tile('Center', child.enrolmentCenter ?? '-'),
 _tile('Aadhaar', child.aadhaar?.status ?? 'Not linked'),
 const SizedBox(height: 16),
 Text('Guardians', style: Theme.of(context).textTheme.titleMedium),
 ...child.guardians.map((g) => ListTile(
 title: Text(g.name),
 subtitle: Text('${g.relationship} · ${g.phone}'),
 trailing: Text(g.accessLevel),
 )),
 ],
 ),
 // BIOMETRICS
 ListView(
 padding: const EdgeInsets.all(16),
 children: [
 Text('${child.fingerprints.length} fingerprints on record',
 style: Theme.of(context).textTheme.titleMedium),
 const SizedBox(height: 8),
 ...child.fingerprints.map((f) => ListTile(
 dense: true,
 title: Text('${f.hand} ${f.finger}'),
 subtitle: Text('Quality ${f.qualityPercent}%'),
 )),
 ],
 ),
 // BLOCKCHAIN
 ListView(
 padding: const EdgeInsets.all(16),
 children: [
 if (child.blockchain == null)
 const Text('No blockchain record')
 else ...[
 ListTile(
 title: const Text('Transaction ID'),
 subtitle: Text(child.blockchain!.transactionId,
 style: AppTextStyles.mono(context)),
 trailing: IconButton(
 icon: const Icon(Icons.copy),
 onPressed: () => Clipboard.setData(
 ClipboardData(text: child.blockchain!.transactionId)),
 ),
 ),
 ListTile(
 title: const Text('Status'),
 trailing: Chip(
 label: Text(child.blockchain!.verified ? 'Verified' : 'Mismatch'),
 ),
 ),
 ListTile(
 title: const Text('Anchored Hash'),
 subtitle: Text(child.blockchain!.anchoredHash,
 style: AppTextStyles.mono(context)),
 ),
 ],
 ],
 ),
 // IOT
 const Center(child: Text('No IoT device data yet')),
 ],
 ),
 ),
 ),
 );
 }

 Widget _tile(String label, String value) => ListTile(
 dense: true,
 title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
 subtitle: Text(value, style: const TextStyle(fontSize: 16)),
 );
}
