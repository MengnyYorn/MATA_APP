// lib/modules/auth/register/register_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepo = Get.find();

  final formKey    = GlobalKey<FormState>();
  final nameCtrl   = TextEditingController();
  final emailCtrl  = TextEditingController();
  final passCtrl   = TextEditingController();
  final confirmCtrl = TextEditingController();

  final isLoading = false.obs;

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final result = await _authRepo.register(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passCtrl.text,
    );
    isLoading.value = false;

    result.fold(
      (failure) => Get.snackbar(
        'Registration Failed', failure.message,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      ),
      (_) => Get.offAllNamed(AppRoutes.home),
    );
  }
}
