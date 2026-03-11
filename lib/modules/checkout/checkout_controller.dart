// lib/modules/checkout/checkout_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/order_repository.dart';
import '../cart/cart_controller.dart';
import '../../routes/app_routes.dart';

class CheckoutController extends GetxController {
  final OrderRepository _orderRepo = Get.find();
  final CartController  _cart      = Get.find();

  final isLoading = false.obs;

  Future<void> placeOrder() async {
    isLoading.value = true;
    final result = await _orderRepo.placeOrder(_cart.items.toList());
    isLoading.value = false;

    result.fold(
      (f) => Get.snackbar('Error', f.message,
          backgroundColor: Colors.red, colorText: Colors.white),
      (order) {
        _cart.clear();
        Get.offAllNamed(AppRoutes.orders);
        Get.snackbar(
          'Order placed! 🎉',
          'Order #${order.id} is confirmed.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      },
    );
  }
}
