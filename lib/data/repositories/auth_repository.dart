// lib/data/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

// Failure type
class Failure {
  final String message;
  const Failure(this.message);
}

class AuthRepository {
  final _box = GetStorage();

  // ── Static mock auth ─────────────────────────────────────────────
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      return Left(const Failure('Email and password are required'));
    }
    if (!email.contains('@')) {
      return Left(const Failure('Invalid email address'));
    }
    if (password.length < 6) {
      return Left(const Failure('Password must be at least 6 characters'));
    }

    // Mock user returned
    final user = UserModel(
      id: '1',
      name: email.split('@')[0].replaceAll('.', ' ').split(' ')
          .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' '),
      email: email,
      role: email.contains('admin') ? 'ADMIN' : 'CUSTOMER',
      avatar: email.substring(0, 2).toUpperCase(),
    );

    // Persist session
    await _box.write(AppConstants.keyAccessToken, 'mock_access_token_${user.id}');
    await _box.write(AppConstants.keyUser, user.toJson());

    return Right(user);
  }

  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return Left(const Failure('All fields are required'));
    }

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      role: 'CUSTOMER',
      avatar: name.substring(0, name.length.clamp(0, 2)).toUpperCase(),
    );

    await _box.write(AppConstants.keyAccessToken, 'mock_access_token_${user.id}');
    await _box.write(AppConstants.keyUser, user.toJson());

    return Right(user);
  }

  Future<void> logout() async {
    await _box.remove(AppConstants.keyAccessToken);
    await _box.remove(AppConstants.keyUser);
  }

  bool get isLoggedIn => _box.read(AppConstants.keyAccessToken) != null;

  UserModel? get currentUser {
    final json = _box.read(AppConstants.keyUser);
    if (json == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(json));
  }
}
