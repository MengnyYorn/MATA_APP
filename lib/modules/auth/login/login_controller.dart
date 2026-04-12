// lib/modules/auth/login/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepo = Get.find();

  final formKey = GlobalKey<FormState>();
  final emailCtrl    = TextEditingController();
  final passwordCtrl = TextEditingController();

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final result = await _authRepo.login(
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text,
    );
    isLoading.value = false;

    result.fold(
      (failure) => AppSnackbar.error('Login Failed', failure.message),
      (_) => popOrGoHome(),
    );
  }

  Future<void> signInWithGoogle() async {
    isGoogleLoading.value = true;
    final result = await _authRepo.signInWithGoogle();
    isGoogleLoading.value = false;

    result.fold(
      (failure) =>
          AppSnackbar.error('Google sign-in failed', failure.message),
      (_) => popOrGoHome(),
    );
  }

  void goToRegister() => Get.toNamed(AppRoutes.register);
}
