// lib/modules/checkout/checkout_binding.dart
import 'package:get/get.dart';
import 'checkout_controller.dart';
import '../../data/repositories/order_repository.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderRepository());
    Get.lazyPut(() => CheckoutController());
  }
}
