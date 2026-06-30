import 'package:flutter/material.dart';

import '../theme/light_theme.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final ext = CureBlockThemeExtension.of(context);
    final normalized = status.toLowerCase();

    final (Color bg, Color fg, String label) = switch (normalized) {
      'active' || 'safe' => (ext.safe, ext.safe, 'Active'),
      'missing' || 'alert' => (ext.danger, ext.danger, _capitalize(status)),
      'rescued' => (ext.rescued, ext.rescued, 'Rescued'),
      'warning' => (ext.warning, ext.warning, 'Warning'),
      _ => (ext.textSecondary, ext.textSecondary, _capitalize(status)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bg.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
