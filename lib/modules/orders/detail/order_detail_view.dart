// lib/modules/orders/detail/order_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/order_model.dart';
import '../../../routes/app_routes.dart';
import 'order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          // Use an explicit route so back works even when the navigation
          // stack is lost (e.g. after a refresh / deep-link).
          onPressed: () => Get.offNamed(AppRoutes.orders),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final order = controller.order.value;
        if (order == null) return const SizedBox();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.id.split('-').last}',
                          style: AppTextStyles.headline2),
                      const SizedBox(height: 4),
                      Text(order.date, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 32),

              // ── Tracking ────────────────────────────────────────
              Text('TRACK ORDER',
                  style: AppTextStyles.labelSmall.copyWith(letterSpacing: 2)),
              const SizedBox(height: 20),
              _TrackingTimeline(status: order.status),

              const SizedBox(height: 32),

              // ── Order Summary ───────────────────────────────────
              Text('ORDER SUMMARY',
                  style: AppTextStyles.labelSmall.copyWith(letterSpacing: 2)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _Row('Items (${order.itemCount})',
                        '\$${order.total.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _Row('Shipping', 'Free',
                        valueColor: AppColors.success),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: AppTextStyles.headline3),
                        Text('\$${order.total.toStringAsFixed(2)}',
                            style: AppTextStyles.priceLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _Row(this.label, this.value, {this.valueColor});

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

class _TrackingTimeline extends StatelessWidget {
  final OrderStatus status;
  const _TrackingTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _Step('Order Placed', OrderStatus.pending),
      _Step('Processing', OrderStatus.pending),
      _Step('Shipped', OrderStatus.shipped),
      _Step('Delivered', OrderStatus.delivered),
    ];

    final activeIdx = status == OrderStatus.cancelled
        ? -1
        : steps.indexWhere((s) => s.status == status);

    return Column(
      children: List.generate(steps.length, (i) {
        final completed = i <= activeIdx;
        final isLast = i == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: completed ? AppColors.primary : AppColors.divider,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    completed ? Icons.check_rounded : Icons.circle,
                    size: completed ? 14 : 8,
                    color: completed ? Colors.white : AppColors.textHint,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 36,
                    color: i < activeIdx ? AppColors.primary : AppColors.divider,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                steps[i].label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: completed
                      ? AppColors.textPrimary
                      : AppColors.textHint,
                  fontWeight:
                      completed ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Step {
  final String label;
  final OrderStatus status;
  const _Step(this.label, this.status);
}
