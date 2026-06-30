import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/child_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/sign_out_button.dart';
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(adminStatsProvider);
    final logs = ref.watch(auditLogsProvider).take(5).toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.push('/admin/audit'),
            icon: const Icon(Icons.history),
          ),
          const SignOutButton(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _gridStat('${stats.totalEnrolled}', 'Total Enrolled', Icons.groups),
              _gridStat('${stats.active}', 'Active', Icons.check_circle_outline),
              _gridStat('${stats.missing}', 'Missing', Icons.person_off_outlined),
              _gridStat('${stats.rescued}', 'Rescued', Icons.emergency_share),
            ],
          ),
          const SizedBox(height: 24),
          Text('Enrolments (30 days)', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < stats.enrolmentTrend.length; i++)
                        FlSpot(i.toDouble(), stats.enrolmentTrend[i]),
                    ],
                    isCurved: true,
                    color: AppColors.accent,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.accent.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Recent audit log', style: theme.textTheme.titleMedium),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/admin/audit'),
                child: const Text('View all'),
              ),
            ],
          ),
          ...logs.map(
            (log) => ListTile(
              leading: CircleAvatar(child: Text(log.userName[0])),
              title: Text(log.userName),
              subtitle: Text('${log.action.label} · ${log.recordId}'),
              trailing: Text(DateFormat.Hm().format(log.timestamp)),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.push('/admin/blockchain'),
            child: const Text('Blockchain integrity'),
          ),
        ],
      ),
    );
  }

  Widget _gridStat(String value, String label, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.accent),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
