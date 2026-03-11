// lib/modules/orders/detail/order_detail_binding.dart
import 'package:get/get.dart';
import 'order_detail_controller.dart';
import '../../../data/repositories/order_repository.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderRepository());
    Get.lazyPut(() => OrderDetailController());
  }
}
