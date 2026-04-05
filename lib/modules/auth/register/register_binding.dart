// lib/modules/auth/register/register_binding.dart
import 'package:get/get.dart';
import 'register_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut(() => AuthRepository());
    }
    Get.lazyPut(() => RegisterController());
  }
}
