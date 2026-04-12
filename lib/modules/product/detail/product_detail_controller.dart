// lib/modules/product/detail/product_detail_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../cart/cart_controller.dart';
import '../../../routes/app_routes.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _repo = Get.find();

  final product      = Rxn<ProductModel>();
  final isLoading    = true.obs;
  final selectedSize  = ''.obs;
  final selectedColor = ''.obs;
  final quantity     = 1.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.parameters['id'] ?? '';
    _loadProduct(id);
  }

  Future<void> _loadProduct(String id) async {
    isLoading.value = true;
    final result = await _repo.getProductById(id);
    result.fold(
      (f) {
        Get.back();
        AppSnackbar.error('Error', f.message);
      },
      (p) {
        product.value = p;
        if (p.sizes.isNotEmpty)  selectedSize.value  = p.sizes.first;
        if (p.colors.isNotEmpty) selectedColor.value = p.colors.first;
      },
    );
    isLoading.value = false;
  }

  void incrementQty() {
    if (quantity.value < (product.value?.stock ?? 1)) quantity.value++;
  }
  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    final p = product.value;
    if (p == null) return;

    if (selectedSize.value.isEmpty || selectedColor.value.isEmpty) {
      AppSnackbar.warning(
          'Select options', 'Please select size and color');
      return;
    }

    // Check auth before adding
    final auth = Get.find<AuthRepository>();
    if (!auth.isLoggedIn) {
      Get.dialog(_AuthDialog());
      return;
    }

    Get.find<CartController>().addItem(
      product: p,
      size: selectedSize.value,
      color: selectedColor.value,
      qty: quantity.value,
    );

    AppSnackbar.success(
      'Added to cart',
      '${p.name} — ${selectedSize.value} / ${selectedColor.value}',
      duration: const Duration(seconds: 2),
    );
  }
}

class _AuthDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Sign in required'),
      content: const Text('Please sign in to add items to your cart.'),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.toNamed(AppRoutes.login);
          },
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
