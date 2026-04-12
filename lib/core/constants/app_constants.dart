// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'MATA';
  static const String appTagline = 'Shop';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'http://192.168.0.209:8087/api/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Web application OAuth client ID — must match Spring `GOOGLE_CLIENT_ID` (ID token audience).
  /// Override per env: `--dart-define=GOOGLE_SERVER_CLIENT_ID=other...apps.googleusercontent.com`
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '531021898835-0b3ssb67tvilmst0j9f8j9vgs53trfqv.apps.googleusercontent.com',
  );

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

  /// Used only if GET /categories fails (offline / error). Home loads live categories from the API.
  static const List<String> fallbackCategoryNames = [
    'Dresses',
    'Knitwear',
    'Tops',
    'Bottoms',
    'Outerwear',
  ];
}
