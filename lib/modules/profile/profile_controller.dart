// lib/modules/profile/profile_controller.dart

import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepo = Get.find();

  final user = Rxn<UserModel>();
  Worker? _sessionWorker;

  @override
  void onInit() {
    super.onInit();
    user.value = _authRepo.currentUser;
    _sessionWorker = ever(_authRepo.sessionRevision, (_) {
      user.value = _authRepo.currentUser;
    });
  }

  @override
  void onClose() {
    _sessionWorker?.dispose();
    super.onClose();
  }

  String get displayName => user.value?.name.isNotEmpty == true
      ? user.value!.name
      : 'Guest user';

  String get email => user.value?.email ?? '-';

  String get roleLabel =>
      (user.value?.role ?? 'CUSTOMER').toUpperCase();

  String get initials => user.value?.initials ?? 'GU';

  bool get isLoggedIn => _authRepo.isLoggedIn;

  Future<void> goToOrders() async {
    Get.toNamed(AppRoutes.orders);
  }

  Future<void> logout() async {
    await _authRepo.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}

