import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/child_provider.dart';

class GuardianManagementScreen extends ConsumerWidget {
  const GuardianManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guardians = ref.watch(guardiansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Guardians')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add Guardian'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: guardians.length,
        itemBuilder: (context, index) {
          final g = guardians[index];
          return Dismissible(
            key: ValueKey(g.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Theme.of(context).colorScheme.error,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${g.name} removed')),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(child: Text(g.name[0])),
                title: Text(g.name),
                subtitle: Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(g.relationship), visualDensity: VisualDensity.compact),
                    Chip(label: Text(g.accessLevel.label), visualDensity: VisualDensity.compact),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
