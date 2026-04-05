// lib/modules/profile/profile_binding.dart

import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../data/repositories/auth_repository.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut(() => AuthRepository());
    }
    Get.lazyPut(() => ProfileController());
  }
}

