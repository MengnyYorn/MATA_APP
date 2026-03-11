// lib/modules/orders/list/order_list_binding.dart
import 'package:get/get.dart';
import 'order_list_controller.dart';
import '../../../data/repositories/order_repository.dart';

class OrderListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderRepository());
    Get.lazyPut(() => OrderListController());
  }
}
