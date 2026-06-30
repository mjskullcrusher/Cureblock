import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/alert_model.dart';
import '../theme/light_theme.dart';
import 'status_badge.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({super.key, required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = CureBlockThemeExtension.of(context);
    final accent = _accentColor(ext, alert.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: accent, width: 4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_iconForType(alert.type), color: accent, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alert.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    alert.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ext.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _relativeTime(alert.timestamp),
                        style: theme.textTheme.labelSmall,
                      ),
                      const Spacer(),
                      StatusBadge(
                        status: alert.status == AlertStatus.active
                            ? 'active'
                            : 'resolved',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _accentColor(CureBlockThemeExtension ext, AlertType type) {
    return switch (type) {
      AlertType.geofenceBreach => ext.danger,
      AlertType.deviceWarning => ext.warning,
      AlertType.resolved => ext.safe,
    };
  }

  IconData _iconForType(AlertType type) {
    return switch (type) {
      AlertType.geofenceBreach => Icons.location_off_rounded,
      AlertType.deviceWarning => Icons.battery_alert_rounded,
      AlertType.resolved => Icons.check_circle_outline_rounded,
    };
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('d MMM').format(time);
  }
}
