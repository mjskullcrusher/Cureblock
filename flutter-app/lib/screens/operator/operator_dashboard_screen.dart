import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/auth_provider.dart';
import '../../providers/child_provider.dart';
import '../../widgets/sign_out_button.dart';
import '../../widgets/stat_card.dart';

class OperatorDashboardScreen extends ConsumerWidget {
  const OperatorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(currentUserNameProvider);
    final stats = ref.watch(operatorStatsProvider);
    final activity = ref.watch(operatorRecentActivityProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Operator'),
        actions: const [SignOutButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(child: Text('Good morning, $name', style: theme.textTheme.headlineSmall)),
              const Chip(label: Text('Field Operator'), avatar: Icon(Icons.badge, size: 18)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              StatCard(
                value: '${stats.todaysEnrolments}',
                label: "Today's Enrolments",
                icon: Icons.person_add,
              ),
              const SizedBox(width: 8),
              StatCard(
                value: '${stats.pendingVerifications}',
                label: 'Pending Verifications',
                icon: Icons.pending_actions,
              ),
              const SizedBox(width: 8),
              StatCard(
                value: '${stats.rescueMatches}',
                label: 'Rescue Matches',
                icon: Icons.emergency,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Quick Actions', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.assignment,
            label: 'New Enrolment',
            onTap: () => context.pushNamed('operator-enrolment'),
          ),
          _ActionCard(
            icon: Icons.search,
            label: 'Search Child',
            onTap: () => context.push('/operator/search'),
          ),
          _ActionCard(
            icon: Icons.fingerprint,
            label: 'Identify Rescued Child',
            onTap: () => context.push('/operator/identify'),
          ),
          const SizedBox(height: 24),
          Text('Recent Activity', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...activity.map(
            (e) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(e.label),
              trailing: Text(
                DateFormat.Hm().format(e.timestamp),
                style: theme.textTheme.labelSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
