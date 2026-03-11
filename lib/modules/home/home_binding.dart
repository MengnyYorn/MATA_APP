// lib/modules/home/home_binding.dart
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/wishlist_repository.dart';
import '../cart/cart_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => ProductRepository());
    Get.lazyPut(() => WishlistRepository());
    Get.put(CartController(), permanent: true);
    Get.lazyPut(() => HomeController());
  }
}
