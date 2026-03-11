// lib/modules/product/list/product_list_binding.dart
import 'package:get/get.dart';
import 'product_list_controller.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/wishlist_repository.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductRepository());
    Get.lazyPut(() => WishlistRepository());
    Get.lazyPut(() => ProductListController());
  }
}
