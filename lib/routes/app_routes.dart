// lib/routes/app_routes.dart

abstract class AppRoutes {
  static const splash   = '/';
  static const login    = '/login';
  static const register = '/register';
  static const home     = '/home';
  static const products = '/products';
  static const productDetail = '/product/:id';
  static const cart     = '/cart';
  static const checkout = '/checkout';
  static const orders   = '/orders';
  static const orderDetail = '/order/:id';

  static String productDetailPath(String id) => '/product/$id';
  static String orderDetailPath(String id)   => '/order/$id';
}
