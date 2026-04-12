// lib/modules/home/home_controller.dart
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_snackbar.dart';
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
  /// Chips: always starts with `All`, then API category names (see [loadCategories]).
  final categories   = <String>['All'].obs;

  @override
  void onInit() {
    super.onInit();
    Future.wait([loadCategories(), loadProducts()]);
  }

  Future<void> loadCategories() async {
    final result = await _productRepo.getCategories();
    result.fold(
      (f) {
        categories.value = ['All', ...AppConstants.fallbackCategoryNames];
        AppSnackbar.error('Categories', f.message);
      },
      (names) {
        if (names.isEmpty) {
          categories.value = ['All', ...AppConstants.fallbackCategoryNames];
        } else {
          categories.value = ['All', ...names];
        }
        final sel = selectedCat.value;
        if (sel != 'All' && !categories.contains(sel)) {
          selectedCat.value = 'All';
        }
      },
    );
  }

  Future<void> refreshHome() async {
    await loadCategories();
    await loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    final result = await _productRepo.getProducts(
      category: selectedCat.value == 'All' ? null : selectedCat.value,
    );
    result.fold(
      (f) => AppSnackbar.error('Error', f.message),
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
