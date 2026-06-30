import 'package:flutter/material.dart';

import '../theme/light_theme.dart';

class BiometricTimeline extends StatelessWidget {
  const BiometricTimeline({
    super.key,
    required this.milestones,
    this.labels = const ['Birth', '2yr', '5yr', '15yr'],
  });

  /// Each entry: `true` = completed milestone.
  final List<bool> milestones;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = CureBlockThemeExtension.of(context);
    final count = milestones.length.clamp(0, labels.length);

    return SizedBox(
      height: 72,
      child: Row(
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 2,
                  color: milestones[i - 1]
                      ? theme.colorScheme.primary
                      : theme.dividerColor,
                ),
              ),
            _MilestoneNode(
              label: labels[i],
              completed: milestones[i],
              primary: theme.colorScheme.primary,
              secondary: ext.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}

class _MilestoneNode extends StatelessWidget {
  const _MilestoneNode({
    required this.label,
    required this.completed,
    required this.primary,
    required this.secondary,
  });

  final String label;
  final bool completed;
  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed ? primary : Colors.transparent,
            border: Border.all(
              color: completed ? primary : secondary.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: completed
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: completed ? primary : secondary,
            fontWeight: completed ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
