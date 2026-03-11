// lib/modules/splash/splash_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Fail-safe: ensure we never get stuck on splash.
    // Any error here should send the user to Login rather than hanging.
    _navigate().catchError((e, st) {
      debugPrint('Splash navigation failed: $e');
      debugPrintStack(stackTrace: st);
      _goLoginFallback();
    });
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('Splash -> route to home (no-login)');
    Get.offAllNamed(AppRoutes.home);
  }

  void _goLoginFallback() {
    // Avoid infinite loops if routing is broken.
    if (Get.currentRoute == AppRoutes.login) return;
    Get.offAllNamed(AppRoutes.login);
  }
}
