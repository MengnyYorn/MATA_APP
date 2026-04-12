// lib/core/utils/app_snackbar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

/// Central [Get.snackbar] styling: top placement, solid colors, no blur (readable).
class AppSnackbar {
  AppSnackbar._();

  static EdgeInsets _margin() {
    final ctx = Get.context;
    if (ctx == null) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
    final top = MediaQuery.paddingOf(ctx).top + 8;
    return EdgeInsets.fromLTRB(16, top, 16, 8);
  }

  static void show(
    String title,
    String message, {
    Color? backgroundColor,
    Color colorText = Colors.white,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: backgroundColor ?? AppColors.primary,
      colorText: colorText,
      barBlur: 0,
      overlayBlur: 0,
      margin: _margin(),
      borderRadius: 12,
      duration: duration,
    );
  }

  static void error(String title, String message) {
    show(title, message, backgroundColor: AppColors.error);
  }

  static void success(String title, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    show(title, message,
        backgroundColor: AppColors.success, duration: duration);
  }

  /// Neutral notices (validation, hints) — dark bar, white text.
  static void info(String title, String message) {
    show(title, message, backgroundColor: AppColors.primary);
  }

  /// Warnings — solid amber tone, dark text for contrast.
  static void warning(String title, String message) {
    show(
      title,
      message,
      backgroundColor: const Color(0xFFD97706),
      colorText: Colors.white,
    );
  }
}
