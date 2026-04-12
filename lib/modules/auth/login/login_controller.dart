// lib/modules/auth/login/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepo = Get.find();

  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  /// false = password, true = email OTP
  final useOtp = false.obs;

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isSendingLoginOtp = false.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    otpCtrl.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final result = useOtp.value
        ? await _authRepo.loginWithOtp(
            email: emailCtrl.text.trim(),
            otp: otpCtrl.text.trim(),
          )
        : await _authRepo.login(
            email: emailCtrl.text.trim(),
            password: passwordCtrl.text,
          );
    isLoading.value = false;

    result.fold(
      (failure) => AppSnackbar.error('Login Failed', failure.message),
      (_) => popOrGoHome(),
    );
  }

  Future<void> sendLoginOtp() async {
    if (emailCtrl.text.trim().isEmpty || !emailCtrl.text.contains('@')) {
      AppSnackbar.info('Email required', 'Enter a valid account email first.');
      return;
    }
    isSendingLoginOtp.value = true;
    final result =
        await _authRepo.sendLoginOtp(email: emailCtrl.text.trim());
    isSendingLoginOtp.value = false;
    result.fold(
      (f) => AppSnackbar.error('Could not send code', f.message),
      (_) => AppSnackbar.success(
        'Code sent',
        'Check your email for the sign-in code.',
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    isGoogleLoading.value = true;
    try {
      final result = await _authRepo.signInWithGoogle();
      result.fold(
        (failure) =>
            AppSnackbar.error('Google sign-in failed', failure.message),
        (_) => popOrGoHome(),
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void goToRegister() => Get.toNamed(AppRoutes.register);
}
