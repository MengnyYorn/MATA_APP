// lib/modules/orders/detail/order_detail_controller.dart
import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

class OrderDetailController extends GetxController {
  final OrderRepository _repo = Get.find();
  final order = Rxn<OrderModel>();
  final isLoading = true.obs;

  String get _routeOrderId => Get.parameters['id'] ?? '';

  @override
  void onInit() {
    super.onInit();
    _load(_routeOrderId);
  }

  Future<void> _load(String id) async {
    isLoading.value = true;
    final result = await _repo.getOrderById(id);
    result.fold((f) {
      Get.back();
    }, (o) => order.value = o);
    isLoading.value = false;
  }

  /// Pull-to-refresh or app bar — reload status and totals without leaving the screen.
  Future<void> reloadOrder() async {
    final id = _routeOrderId.isNotEmpty ? _routeOrderId : (order.value?.id ?? '');
    if (id.isEmpty) return;

    final result = await _repo.getOrderById(id);
    result.fold(
      (f) => AppSnackbar.error('Error', f.message),
      (o) => order.value = o,
    );
  }
}
