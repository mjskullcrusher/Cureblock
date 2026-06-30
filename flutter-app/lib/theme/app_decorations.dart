import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared card and surface decorations per design system.
abstract final class AppDecorations {
  static const double cardRadius = 18;
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(cardRadius));

  static List<BoxShadow> get cardShadow => const [
        BoxShadow(
          color: AppColors.cardShadow,
          blurRadius: 12,
          offset: Offset(0, 2),
        ),
      ];

  static BoxDecoration card({Color? color, List<BoxShadow>? shadows}) {
    return BoxDecoration(
      color: color,
      borderRadius: cardBorderRadius,
      boxShadow: shadows ?? cardShadow,
    );
  }
}
