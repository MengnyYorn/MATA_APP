// lib/modules/checkout/checkout_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../cart/cart_controller.dart';
import 'checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: Get.back,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Shipping ─────────────────────────────────────────
            _SectionTitle('Shipping Address'),
            const SizedBox(height: 12),
            _InfoTile(
              icon: Icons.location_on_outlined,
              title: 'Home',
              subtitle: '123 Fashion Ave, Style City, 90210',
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint),
            ),

            const SizedBox(height: 28),

            // ── Payment ──────────────────────────────────────────
            _SectionTitle('Payment Method'),
            const SizedBox(height: 12),
            _InfoTile(
              icon: Icons.credit_card_rounded,
              title: '**** **** **** 4242',
              subtitle: 'VISA  •  Expires 12/26',
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint),
            ),

            const SizedBox(height: 28),

            // ── Order Items ──────────────────────────────────────
            _SectionTitle('Order Items'),
            const SizedBox(height: 12),
            ...cart.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.product.name}  ×${item.quantity}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  Text(
                    '\$${item.subtotal.toStringAsFixed(2)}',
                    style: AppTextStyles.labelLarge,
                  ),
                ],
              ),
            )),

            const Divider(height: 32),

            // ── Summary ──────────────────────────────────────────
            _SummaryRow('Subtotal',
                '\$${cart.totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _SummaryRow('Shipping', 'Free',
                valueColor: AppColors.success),
            const SizedBox(height: 8),
            _SummaryRow('Tax (8.5%)',
                '\$${(cart.totalPrice * 0.085).toStringAsFixed(2)}'),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: AppTextStyles.headline3),
                Text(
                  '\$${(cart.totalPrice * 1.085).toStringAsFixed(2)}',
                  style: AppTextStyles.priceLarge,
                ),
              ],
            ),

            const SizedBox(height: 40),

            Obx(() => AppButton(
              label: 'PLACE ORDER',
              onPressed: controller.placeOrder,
              isLoading: controller.isLoading.value,
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(letterSpacing: 2),
      );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  const _InfoTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _SummaryRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
          Text(value,
              style: AppTextStyles.labelLarge
                  .copyWith(color: valueColor ?? AppColors.textPrimary)),
        ],
      );
}
