// lib/core/widgets/status_badge.dart

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../data/models/order_model.dart';

class StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const StatusBadge({super.key, required this.status});

  Color get _bg {
    switch (status) {
      case OrderStatus.pending:   return AppColors.statusPending.withOpacity(0.12);
      case OrderStatus.shipped:   return AppColors.statusShipped.withOpacity(0.12);
      case OrderStatus.delivered: return AppColors.statusDelivered.withOpacity(0.12);
      case OrderStatus.cancelled: return AppColors.statusCancelled.withOpacity(0.12);
    }
  }

  Color get _fg {
    switch (status) {
      case OrderStatus.pending:   return AppColors.statusPending;
      case OrderStatus.shipped:   return AppColors.statusShipped;
      case OrderStatus.delivered: return AppColors.statusDelivered;
      case OrderStatus.cancelled: return AppColors.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(color: _fg, letterSpacing: 1),
      ),
    );
  }
}
