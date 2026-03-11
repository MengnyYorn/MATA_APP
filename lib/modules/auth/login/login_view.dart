// lib/modules/auth/login/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                const SizedBox(height: 60),

                // Logo
                Center(
                  child: Column(
                    children: [
                      Text('MATA',
                          style: AppTextStyles.display.copyWith(letterSpacing: 8)),
                      Text('BOUTIQUE',
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
                const SizedBox(height: 36),

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

                // Password
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: controller.passwordCtrl,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: controller.login,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot password?',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 24),

                // Login button
                Obx(() => AppButton(
                  label: 'SIGN IN',
                  onPressed: controller.login,
                  isLoading: controller.isLoading.value,
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
