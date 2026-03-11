// lib/modules/orders/detail/order_detail_controller.dart
import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

class OrderDetailController extends GetxController {
  final OrderRepository _repo = Get.find();
  final order     = Rxn<OrderModel>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.parameters['id'] ?? '';
    _load(id);
  }

  Future<void> _load(String id) async {
    isLoading.value = true;
    final result = await _repo.getOrderById(id);
    result.fold((f) { Get.back(); }, (o) => order.value = o);
    isLoading.value = false;
  }
}
