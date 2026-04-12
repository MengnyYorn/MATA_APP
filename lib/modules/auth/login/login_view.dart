// lib/modules/auth/login/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: popOrGoHome,
                    tooltip: 'Back',
                  ),
                ),
                const SizedBox(height: 16),

                // Logo
                Center(
                  child: Column(
                    children: [
                      Text('MATA',
                          style: AppTextStyles.display.copyWith(letterSpacing: 8)),
                      Text('SHOP',
                          style: AppTextStyles.labelSmall.copyWith(letterSpacing: 6)),
                    ],
                  ),
                ),
                const SizedBox(height: 56),

                Text('Welcome back', style: AppTextStyles.headline1),
                const SizedBox(height: 6),
                Text('Sign in to your account',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 20),

                Obx(() => Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: !controller.useOtp.value
                                  ? AppColors.primary
                                  : null,
                              foregroundColor: !controller.useOtp.value
                                  ? Colors.white
                                  : AppColors.primary,
                              side: const BorderSide(
                                  color: AppColors.border, width: 1.5),
                            ),
                            onPressed: () => controller.useOtp.value = false,
                            child: const Text('Password'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: controller.useOtp.value
                                  ? AppColors.primary
                                  : null,
                              foregroundColor: controller.useOtp.value
                                  ? Colors.white
                                  : AppColors.primary,
                              side: const BorderSide(
                                  color: AppColors.border, width: 1.5),
                            ),
                            onPressed: () => controller.useOtp.value = true,
                            child: const Text('Email code'),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 24),

                // Email
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

                Obx(() => controller.useOtp.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Obx(() => OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                ),
                                onPressed: controller.isSendingLoginOtp.value
                                    ? null
                                    : controller.sendLoginOtp,
                                child: controller.isSendingLoginOtp.value
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text('Send sign-in code'),
                              )),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Code',
                            hint: '000000',
                            controller: controller.otpCtrl,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.pin_outlined,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: controller.login,
                            validator: (v) {
                              if (!controller.useOtp.value) return null;
                              if (v == null || v.trim().isEmpty) {
                                return 'Enter the code from your email';
                              }
                              if (v.trim().length < 4) {
                                return 'Invalid code';
                              }
                              return null;
                            },
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            label: 'Password',
                            hint: '••••••••',
                            controller: controller.passwordCtrl,
                            isPassword: true,
                            prefixIcon: Icons.lock_outline_rounded,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: controller.login,
                            validator: (v) {
                              if (controller.useOtp.value) return null;
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              if (v.length < 6) return 'At least 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text('Forgot password?',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: AppColors.primary)),
                            ),
                          ),
                        ],
                      )),

                const SizedBox(height: 24),

                // Login button
                Obx(() => AppButton(
                  label: 'SIGN IN',
                  onPressed: controller.login,
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

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: controller.goToRegister,
                      child: Text('Sign up',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.primary,
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
