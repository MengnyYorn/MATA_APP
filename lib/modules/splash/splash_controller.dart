// lib/modules/splash/splash_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepo = Get.find();

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

    final loggedIn = _authRepo.isLoggedIn;
    debugPrint('Splash -> loggedIn=$loggedIn');

    final target = loggedIn ? AppRoutes.home : AppRoutes.login;
    Get.offAllNamed(target);
  }

  void _goLoginFallback() {
    // Avoid infinite loops if routing is broken.
    if (Get.currentRoute == AppRoutes.login) return;
    Get.offAllNamed(AppRoutes.login);
  }
}
