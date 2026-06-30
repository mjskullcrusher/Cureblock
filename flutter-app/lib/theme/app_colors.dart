import 'package:flutter/material.dart';

/// CureBlock design tokens for light and dark surfaces.
abstract final class AppColors {
  // Light mode
  static const scaffoldBg = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const primaryBrand = Color(0xFF1E3A5F);
  static const primaryLight = Color(0xFF2E5FA3);
  static const accent = Color(0xFF2563EB);
  static const safe = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
  static const rescued = Color(0xFF2563EB);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const divider = Color(0xFFE2E8F0);

  // Dark mode
  static const scaffoldBgDark = Color(0xFF0D1117);
  static const surfaceDark = Color(0xFF161B27);
  static const cardElevatedDark = Color(0xFF1E2535);
  static const primaryBrandDark = Color(0xFF3B82F6);
  static const safeDark = Color(0xFF34D399);
  static const warningDark = Color(0xFFFBBF24);
  static const dangerDark = Color(0xFFF87171);
  static const textPrimaryDark = Color(0xFFF1F5F9);
  static const textSecondaryDark = Color(0xFF94A3B8);
  static const dividerDark = Color(0xFF1E2D40);

  // Shared
  static const cardShadow = Color(0x14000000);
  static const safeGlow = Color(0x3010B981);
  static const alertGlow = Color(0x30EF4444);
}
