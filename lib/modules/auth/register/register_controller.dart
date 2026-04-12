// lib/modules/auth/register/register_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepo = Get.find();

  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  final isLoading = false.obs;
  final isSendingOtp = false.obs;
  final isGoogleLoading = false.obs;

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    otpCtrl.dispose();
    super.onClose();
  }

  Future<void> sendVerificationCode() async {
    if (nameCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty) {
      AppSnackbar.info('Missing info', 'Enter your name and email first.');
      return;
    }
    if (!emailCtrl.text.contains('@')) {
      AppSnackbar.info('Invalid email', 'Enter a valid email address.');
      return;
    }

    isSendingOtp.value = true;
    final result = await _authRepo.sendRegistrationOtp(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
    );
    isSendingOtp.value = false;

    result.fold(
      (failure) => AppSnackbar.error('Could not send code', failure.message),
      (_) => AppSnackbar.success(
        'Code sent',
        'Check your email for the verification code (in dev, check API logs if using console OTP).',
      ),
    );
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final result = await _authRepo.register(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passCtrl.text,
      otp: otpCtrl.text.trim(),
    );
    isLoading.value = false;

    result.fold(
      (failure) =>
          AppSnackbar.error('Registration Failed', failure.message),
      (_) => popOrGoHome(),
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
}
