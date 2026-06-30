import 'package:flutter/material.dart';

import '../theme/light_theme.dart';

class ConfidenceScoreCard extends StatelessWidget {
  const ConfidenceScoreCard({
    super.key,
    required this.score,
    required this.name,
    required this.age,
    this.dateOfBirth,
    this.onTap,
  });

  final double score;
  final String name;
  final int age;
  final String? dateOfBirth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = CureBlockThemeExtension.of(context);
    final (Color color, String badge) = _badgeForScore(score);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Text(
                  name.isNotEmpty ? name[0] : '?',
                  style: theme.textTheme.titleLarge?.copyWith(color: color),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleMedium),
                    Text(
                      'Age $age${dateOfBirth != null ? ' · DOB $dateOfBirth' : ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, String) _badgeForScore(double score) {
    final pct = (score * 100).round();
    if (score >= 0.95) {
      return (const Color(0xFF10B981), '$pct% — High Confidence');
    }
    if (score >= 0.70) {
      return (const Color(0xFFF59E0B), '$pct% — Possible Match');
    }
    return (const Color(0xFF64748B), 'Low Confidence');
  }
}
