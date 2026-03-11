// lib/modules/auth/register/register_binding.dart
import 'package:get/get.dart';
import 'register_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => RegisterController());
  }
}
