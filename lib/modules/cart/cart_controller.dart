// lib/modules/cart/cart_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../core/constants/app_constants.dart';

class CartController extends GetxController {
  final _box = GetStorage();
  final items = <CartItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCart();
  }

  void _loadCart() {
    final raw = _box.read<List>(AppConstants.keyCart);
    if (raw != null) {
      items.value = raw
          .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  void _saveCart() {
    _box.write(AppConstants.keyCart, items.map((e) => e.toJson()).toList());
  }

  void addItem({
    required ProductModel product,
    required String size,
    required String color,
    int qty = 1,
  }) {
    final key = '${product.id}_${size}_$color';
    final idx = items.indexWhere((i) => i.key == key);

    if (idx >= 0) {
      final existing = items[idx];
      final newQty = (existing.quantity + qty)
          .clamp(1, AppConstants.maxCartQuantity);
      items[idx] = existing.copyWith(quantity: newQty);
    } else {
      items.add(CartItemModel(
        product: product,
        quantity: qty,
        selectedSize: size,
        selectedColor: color,
      ));
    }
    _saveCart();
  }

  void updateQuantity(String key, int quantity) {
    if (quantity < 1) {
      removeItem(key);
      return;
    }
    final idx = items.indexWhere((i) => i.key == key);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: quantity);
      _saveCart();
    }
  }

  void removeItem(String key) {
    items.removeWhere((i) => i.key == key);
    _saveCart();
  }

  void clear() {
    items.clear();
    _saveCart();
  }

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);
  double get totalPrice => items.fold(0, (sum, i) => sum + i.subtotal);
}
