// lib/modules/home/home_controller.dart
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthRepository    _authRepo    = Get.find();
  final ProductRepository _productRepo = Get.find();

  final products     = <ProductModel>[].obs;
  final isLoading    = true.obs;
  final selectedCat  = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    final result = await _productRepo.getProducts(
      category: selectedCat.value == 'All' ? null : selectedCat.value,
    );
    result.fold(
      (f) => Get.snackbar('Error', f.message),
      (data) => products.value = data,
    );
    isLoading.value = false;
  }

  void selectCategory(String cat) {
    selectedCat.value = cat;
    loadProducts();
  }

  void goToProduct(String id) => Get.toNamed(AppRoutes.productDetailPath(id));
  void goToCart()    => Get.toNamed(AppRoutes.cart);
  void goToOrders()  => Get.toNamed(AppRoutes.orders);
  void goToProfile() => Get.toNamed(AppRoutes.profile);

  String get userName => _authRepo.currentUser?.name.split(' ').first ?? 'Guest';

  Future<void> logout() async {
    await _authRepo.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
