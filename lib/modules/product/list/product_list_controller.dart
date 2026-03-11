// lib/modules/product/list/product_list_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../routes/app_routes.dart';

class ProductListController extends GetxController {
  final ProductRepository _repo = Get.find();

  final products    = <ProductModel>[].obs;
  final isLoading   = true.obs;
  final searchCtrl  = TextEditingController();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    debounce(searchQuery, (_) => loadProducts(),
        time: const Duration(milliseconds: 400));
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    final result = await _repo.getProducts(search: searchQuery.value);
    result.fold(
      (f) => Get.snackbar('Error', f.message),
      (data) => products.value = data,
    );
    isLoading.value = false;
  }

  void goToDetail(String id) => Get.toNamed(AppRoutes.productDetailPath(id));
}
