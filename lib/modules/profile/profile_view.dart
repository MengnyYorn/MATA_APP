// lib/modules/profile/profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../routes/app_routes.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        final isLoggedIn = controller.isLoggedIn;

        if (!isLoggedIn) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_outline_rounded,
                      size: 72, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text(
                    'You\'re browsing as guest',
                    style: AppTextStyles.headline3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to view and manage your profile, orders, and preferences.',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    label: 'SIGN IN',
                    onPressed: () => Get.toNamed(AppRoutes.login),
                  ),
                ],
              ),
            ),
          );
        }

        final name = controller.displayName;
        final email = controller.email;
        final role = controller.roleLabel;
        final initials = controller.initials;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: AppTextStyles.headline2
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: AppTextStyles.headline2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'ACCOUNT',
                style: AppTextStyles.labelSmall.copyWith(letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              _Tile(
                icon: Icons.receipt_long_outlined,
                title: 'My Orders',
                subtitle: 'Track and view your order history',
                onTap: controller.goToOrders,
              ),
              const SizedBox(height: 8),
              _Tile(
                icon: Icons.mail_outline_rounded,
                title: 'Email',
                subtitle: email,
                onTap: null,
              ),
              const SizedBox(height: 32),
              Text(
                'SECURITY',
                style: AppTextStyles.labelSmall.copyWith(letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              _Tile(
                icon: Icons.logout_rounded,
                title: 'Sign out',
                subtitle: 'Sign out of this device',
                onTap: controller.logout,
                danger: true,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool danger;

  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = danger ? AppColors.error : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: fg),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(color: fg),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            if (onTap != null && !danger)
              const Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

