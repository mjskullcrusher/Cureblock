import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/child_list_item.dart';
import '../../providers/child_provider.dart';
import '../../widgets/status_badge.dart';

class ChildSearchScreen extends ConsumerStatefulWidget {
 const ChildSearchScreen({super.key});

 @override
 ConsumerState<ChildSearchScreen> createState() => _ChildSearchScreenState();
}

class _ChildSearchScreenState extends ConsumerState<ChildSearchScreen> {
 String _query = '';
 final _statusFilters = <String>{};
 String? _genderFilter;
 String _ageQuery = '';  // typed age, empty = no age filter

 @override
 Widget build(BuildContext context) {
 final asyncChildren = ref.watch(childrenFromApiProvider);

 return Scaffold(
 appBar: AppBar(title: const Text('Search Child')),
 body: Column(
 children: [
 // Name + Age inputs
 Padding(
 padding: const EdgeInsets.all(16),
 child: Row(
 children: [
 Expanded(
 flex: 3,
 child: SearchBar(
 hintText: 'Search by name',
 leading: const Icon(Icons.search),
 onChanged: (v) => setState(() => _query = v),
 ),
 ),
 const SizedBox(width: 8),
 Expanded(
 flex: 1,
 child: TextField(
 keyboardType: TextInputType.number,
 decoration: const InputDecoration(
 hintText: 'Age',
 border: OutlineInputBorder(),
 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
 ),
 onChanged: (v) => setState(() => _ageQuery = v),
 ),
 ),
 ],
 ),
 ),
 // Status + gender chips
 Padding(
 padding: const EdgeInsets.symmetric(horizontal: 16),
 child: Wrap(
 spacing: 8,
 children: [
 ...['active', 'missing', 'rescued'].map((s) {
 final selected = _statusFilters.contains(s);
 return FilterChip(
 label: Text(s[0].toUpperCase() + s.substring(1)),
 selected: selected,
 onSelected: (v) => setState(() {
 if (v) {
 _statusFilters.add(s);
 } else {
 _statusFilters.remove(s);
 }
 }),
 );
 }),
 FilterChip(
 label: const Text('Male'),
 selected: _genderFilter == 'male',
 onSelected: (v) => setState(() => _genderFilter = v ? 'male' : null),
 ),
 FilterChip(
 label: const Text('Female'),
 selected: _genderFilter == 'female',
 onSelected: (v) => setState(() => _genderFilter = v ? 'female' : null),
 ),
 ],
 ),
 ),
 Expanded(
 child: asyncChildren.when(
 loading: () => ListView.builder(
 itemCount: 4,
 itemBuilder: (_, __) => const _SkeletonCard(),
 ),
 error: (err, _) => Center(child: Text('Error loading children:\n$err')),
 data: (allChildren) {
 final children = allChildren.where((c) {
 // name
 if (_query.isNotEmpty &&
 !c.name.toLowerCase().contains(_query.toLowerCase())) {
 return false;
 }
 // exact age
 if (_ageQuery.isNotEmpty) {
 final typedAge = int.tryParse(_ageQuery);
 if (typedAge != null && c.age != typedAge) {
 return false;
 }
 }
 // status
 if (_statusFilters.isNotEmpty &&
 !_statusFilters.contains(c.status.toLowerCase())) {
 return false;
 }
 // gender


 if (_genderFilter != null &&
 c.gender.toLowerCase() != _genderFilter) {
 return false;
 }
 return true;
 }).toList();

 if (children.isEmpty) {
 return const Center(child: Text('No children match your search.'));
 }
 return ListView.builder(
 padding: const EdgeInsets.all(16),
 itemCount: children.length,
 itemBuilder: (_, i) => _ChildResultCard(child: children[i]),
 );
 },
 ),
 ),
 ],
 ),
 );
 }
}

class _ChildResultCard extends StatelessWidget {
 const _ChildResultCard({required this.child});
 final ChildListItem child;

 @override
 Widget build(BuildContext context) {
 return Card(
 margin: const EdgeInsets.only(bottom: 12),
 child: ListTile(
 onTap: () => context.push('/operator/child/${child.id}'),
 leading: CircleAvatar(child: Text(child.name.isNotEmpty ? child.name[0] : '?')),
 title: Text(child.name),
 subtitle: Text('Age ${child.age} · ${child.gender} · ${child.externalSubjectId ?? ''}'),
 trailing: Row(
 mainAxisSize: MainAxisSize.min,
 children: [
 StatusBadge(status: child.status),
 const Icon(Icons.chevron_right),
 ],
 ),
 ),
 );
 }
}

class _SkeletonCard extends StatefulWidget {
 const _SkeletonCard();

 @override
 State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard> {
 bool _highlight = false;

 @override
 void initState() {
 super.initState();
 Future.delayed(const Duration(milliseconds: 400), () {
 if (mounted) setState(() => _highlight = true);
 });
 }

 @override
 Widget build(BuildContext context) {
 return AnimatedContainer(
 duration: const Duration(milliseconds: 600),
 margin: const EdgeInsets.all(16),
 height: 72,
 decoration: BoxDecoration(
 color: _highlight
 ? Theme.of(context).dividerColor.withValues(alpha: 0.5)
 : Theme.of(context).dividerColor.withValues(alpha: 0.25),
 borderRadius: BorderRadius.circular(16),
 ),
 );
 }
}