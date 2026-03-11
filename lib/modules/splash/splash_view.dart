// lib/modules/splash/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MATA',
              style: AppTextStyles.display.copyWith(
                color: Colors.white,
                fontSize: 52,
                letterSpacing: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'BOUTIQUE',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white54,
                letterSpacing: 8,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
