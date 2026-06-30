import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/alert_provider.dart';
import '../../theme/light_theme.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/parent_scaffold.dart';

class ParentAlertsScreen extends ConsumerWidget {
  const ParentAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(alertFilterProvider);
    final alerts = ref.watch(filteredAlertsProvider);
    final ext = CureBlockThemeExtension.of(context);

    return ParentScaffold(
      currentIndex: 2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Text('Alerts', style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SegmentedButton<AlertListFilter>(
                segments: const [
                  ButtonSegment(value: AlertListFilter.all, label: Text('All')),
                  ButtonSegment(value: AlertListFilter.active, label: Text('Active')),
                  ButtonSegment(value: AlertListFilter.resolved, label: Text('Resolved')),
                ],
                selected: {filter},
                onSelectionChanged: (set) {
                  ref.read(alertFilterProvider.notifier).state = set.first;
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: alerts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield_outlined, size: 64, color: ext.safe),
                          const SizedBox(height: 12),
                          Text(
                            'No alerts right now. Your child is safe.',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: alerts.length,
                      itemBuilder: (_, i) => AlertCard(alert: alerts[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
