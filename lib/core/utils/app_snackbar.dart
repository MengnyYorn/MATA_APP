// lib/core/utils/app_snackbar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Central [Get.snackbar] styling: top placement, Material / Android-standard
/// inverse surface colors, no leading icon, no blur.
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

  static ColorScheme? _scheme(BuildContext? ctx) =>
      ctx != null ? Theme.of(ctx).colorScheme : null;

  static TextTheme? _textTheme(BuildContext? ctx) =>
      ctx != null ? Theme.of(ctx).textTheme : null;

  /// All app toasts: same look as platform Snackbar (inverse surface).
  static void show(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final ctx = Get.context;
    final scheme = _scheme(ctx);
    final textTheme = _textTheme(ctx);

    final bg = scheme?.inverseSurface ?? const Color(0xFF323232);
    final fg = scheme?.onInverseSurface ?? const Color(0xFFE0E0E0);

    final titleStyle = textTheme?.titleSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          height: 1.25,
        ) ??
        TextStyle(
          color: fg,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.25,
        );

    final bodyStyle = textTheme?.bodyMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w400,
          height: 1.35,
        ) ??
        TextStyle(
          color: fg,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.35,
        );

    Get.snackbar(
      '',
      '',
      titleText: Text(title, style: titleStyle),
      messageText: Text(message, style: bodyStyle),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: bg,
      icon: null,
      shouldIconPulse: false,
      leftBarIndicatorColor: null,
      barBlur: 0,
      overlayBlur: 0,
      margin: _margin(),
      borderRadius: 4,
      duration: duration,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  static void error(String title, String message) => show(title, message);

  static void success(String title, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    show(title, message, duration: duration);
  }

  static void info(String title, String message) => show(title, message);

  static void warning(String title, String message) => show(title, message);
}
