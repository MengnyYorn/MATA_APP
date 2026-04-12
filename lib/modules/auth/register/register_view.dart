// lib/modules/auth/register/register_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: popOrGoHome,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text('Create account', style: AppTextStyles.headline1),
                const SizedBox(height: 6),
                Text('Join MATA Shop today',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 36),

                AppTextField(
                  label: 'Full Name',
                  hint: 'Jane Doe',
                  controller: controller.nameCtrl,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: controller.emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: controller.passCtrl,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  controller: controller.confirmCtrl,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v != controller.passCtrl.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Verification code',
                        hint: '6-digit code from email',
                        controller: controller.otpCtrl,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.sms_outlined,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: controller.register,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Enter the code from your email';
                          }
                          if (v.trim().length < 4) return 'Invalid code';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Obx(() => OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(108, 44),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                            onPressed: controller.isSendingOtp.value
                                ? null
                                : controller.sendVerificationCode,
                            child: controller.isSendingOtp.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Send code'),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap Send code after entering name and email. Then enter the OTP and create your account.',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                Obx(() => AppButton(
                  label: 'CREATE ACCOUNT',
                  onPressed: controller.register,
                  isLoading: controller.isLoading.value,
                )),
                const SizedBox(height: 16),

                Obx(() => SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                        onPressed: controller.isGoogleLoading.value
                            ? null
                            : controller.signInWithGoogle,
                        icon: controller.isGoogleLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.login_rounded, size: 22),
                        label: const Text('Continue with Google'),
                      ),
                    )),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: Get.back,
                      child: Text('Sign in',
                          style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
