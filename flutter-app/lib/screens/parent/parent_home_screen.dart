import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/child_provider.dart';
import '../../providers/map_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_decorations.dart';
import '../../theme/light_theme.dart';
import '../../widgets/parent_scaffold.dart';
import '../../widgets/stat_card.dart';

class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(selectedChildProvider);
    final name = ref.watch(currentUserNameProvider);
    final mapState = ref.watch(mapProvider);
    final alertCount = ref.watch(activeAlertCountProvider);
    final geofenceLabel = mapState.geofenceBreached ? 'Breached' : 'Active';
    final theme = Theme.of(context);
    final ext = CureBlockThemeExtension.of(context);
    final glow = child.isSafe ? AppColors.safeGlow : AppColors.alertGlow;
    final statusColor = child.isSafe ? ext.safe : ext.danger;

    return ParentScaffold(
      currentIndex: 0,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Good morning, $name 👋',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  onPressed: () => context.go('/parent/alerts'),
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppDecorations.card(color: theme.cardTheme.color).copyWith(
                boxShadow: [
                  BoxShadow(color: glow, blurRadius: 24, offset: const Offset(0, 4)),
                  ...AppDecorations.cardShadow,
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: statusColor.withValues(alpha: 0.15),
                    child: Text(
                      child.name[0],
                      style: theme.textTheme.titleLarge?.copyWith(color: statusColor),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${child.name}, ${child.age}', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            child.isSafe ? 'SAFE' : 'ALERT',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last seen · ${child.currentZone} · ${child.lastSeenLabel}',
                          style: theme.textTheme.bodySmall?.copyWith(color: ext.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Live Map', style: theme.textTheme.titleMedium),
                        const Spacer(),
                        _LiveBadge(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Icon(Icons.map, size: 48)),
                    ),
                    TextButton(
                      onPressed: () => context.go('/parent/map'),
                      child: const Text('View Full Map →'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                StatCard(
                  value: geofenceLabel,
                  label: 'Geofence',
                  icon: Icons.fence_rounded,
                ),
                const SizedBox(width: 8),
                StatCard(
                  value: '${child.iotDevice.batteryPercent}%',
                  label: 'Battery',
                  icon: Icons.battery_charging_full,
                ),
                const SizedBox(width: 8),
                StatCard(
                  value: '$alertCount',
                  label: 'Alerts',
                  icon: Icons.warning_amber_rounded,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ext.danger),
              onPressed: () => context.push('/parent/sos'),
              child: const Text('🚨 SOS Emergency'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: _controller,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 6),
        Text('Live', style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
