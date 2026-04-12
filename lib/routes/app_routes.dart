// lib/routes/app_routes.dart

import 'package:get/get.dart';

abstract class AppRoutes {
  static const splash   = '/';
  static const login    = '/login';
  static const register = '/register';
  static const home     = '/home';
  static const profile  = '/profile';
  static const products = '/products';
  static const productDetail = '/product/:id';
  static const cart     = '/cart';
  static const checkout = '/checkout';
  static const orders   = '/orders';
  static const orderDetail = '/order/:id';

  static String productDetailPath(String id) => '/product/$id';
  static String orderDetailPath(String id)   => '/order/$id';
}

/// Pops when the auth screen was pushed (e.g. from home); otherwise shows home
/// (e.g. login is the only route after logout).
void popOrGoHome() {
  final nav = Get.key.currentState;
  if (nav != null && nav.canPop()) {
    Get.back();
  } else {
    Get.offAllNamed(AppRoutes.home);
  }
}
