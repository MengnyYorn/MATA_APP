// lib/modules/orders/list/order_list_controller.dart
import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../routes/app_routes.dart';

class OrderListController extends GetxController {
  final OrderRepository _repo = Get.find();
  final orders    = <OrderModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() { super.onInit(); loadOrders(); }

  Future<void> loadOrders() async {
    isLoading.value = true;
    final result = await _repo.getMyOrders();
    result.fold(
      (f) => AppSnackbar.error('Error', f.message),
      (data) => orders.value = data,
    );
    isLoading.value = false;
  }

  void goToDetail(String id) => Get.toNamed(AppRoutes.orderDetailPath(id));
}
