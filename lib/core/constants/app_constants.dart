// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'MATA';
  static const String appTagline = 'Boutique';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'http://localhost:8087/api/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String keyAccessToken  = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUser         = 'user';
  static const String keyCart         = 'cart';
  static const String keyOnboarding   = 'onboarding_done';
  static const String keyWishlist     = 'wishlist';

  // Pagination
  static const int pageSize = 20;

  // Cart
  static const int maxCartQuantity = 99;

  // Categories
  static const List<String> categories = [
    'All',
    'Dresses',
    'Knitwear',
    'Tops',
    'Bottoms',
    'Outerwear',
  ];
}
