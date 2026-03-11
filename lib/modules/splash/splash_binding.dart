// lib/modules/splash/splash_binding.dart
import 'package:get/get.dart';
import 'splash_controller.dart';
import '../../data/repositories/auth_repository.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => SplashController());
  }
}
