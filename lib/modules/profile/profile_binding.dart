// lib/modules/profile/profile_binding.dart

import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../data/repositories/auth_repository.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => ProfileController());
  }
}

