// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary    = Color(0xFF1A1A1A);
  static const Color accent     = Color(0xFFB8860B);
  static const Color background = Color(0xFFFAF9F7);
  static const Color surface    = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary   = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint      = Color(0xFF9CA3AF);

  // Status
  static const Color success  = Color(0xFF22C55E);
  static const Color warning  = Color(0xFFF59E0B);
  static const Color error    = Color(0xFFEF4444);
  static const Color info     = Color(0xFF3B82F6);

  // Order status
  static const Color statusPending   = Color(0xFFF59E0B);
  static const Color statusShipped   = Color(0xFF3B82F6);
  static const Color statusDelivered = Color(0xFF22C55E);
  static const Color statusCancelled = Color(0xFFEF4444);

  // UI
  static const Color border     = Color(0xFFE5E7EB);
  static const Color divider    = Color(0xFFF3F4F6);
  static const Color shimmer    = Color(0xFFE5E7EB);
  static const Color overlay    = Color(0x801A1A1A);
  static const Color cardShadow = Color(0x0F000000);
}
