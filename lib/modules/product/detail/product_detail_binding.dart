// lib/modules/product/detail/product_detail_binding.dart
import 'package:get/get.dart';
import 'product_detail_controller.dart';
import '../../../data/repositories/product_repository.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductRepository());
    Get.lazyPut(() => ProductDetailController());
  }
}
