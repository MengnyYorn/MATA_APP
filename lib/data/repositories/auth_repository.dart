// lib/data/repositories/auth_repository.dart

import 'dart:io' show Platform;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

// Failure type (shared by multiple repositories)
class Failure {
  final String message;
  const Failure(this.message);
}

class AuthRepository {
  AuthRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _resolveBaseUrl(AppConstants.baseUrl),
                connectTimeout: AppConstants.connectTimeout,
                receiveTimeout: AppConstants.receiveTimeout,
              ),
            );

  final Dio _dio;
  final _box = GetStorage();

  static String _resolveBaseUrl(String baseUrl) {
    if (Platform.isAndroid && baseUrl.contains('localhost')) {
      return baseUrl.replaceFirst('localhost', '10.0.2.2');
    }
    return baseUrl;
  }

  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return const Left(Failure('Email and password are required'));
    }

    try {
      final res = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final body = res.data;
      final data = (body is Map<String, dynamic>) ? body['data'] : null;
      if (data is! Map) {
        return const Left(Failure('Invalid login response'));
      }

      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      final userJson = data['user'] as Map<String, dynamic>?;

      if (accessToken == null || userJson == null) {
        return const Left(Failure('Missing token or user data'));
      }

      final user = UserModel.fromJson(userJson);

      await _box.write(AppConstants.keyAccessToken, accessToken);
      if (refreshToken != null) {
        await _box.write(AppConstants.keyRefreshToken, refreshToken);
      }
      await _box.write(AppConstants.keyUser, user.toJson());

      return Right(user);
    } on DioException catch (e) {
      final msg =
          e.response?.data is Map && (e.response!.data['message'] is String)
              ? e.response!.data['message'] as String
              : e.message ?? 'Unable to sign in';
      return Left(Failure(msg));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return const Left(Failure('All fields are required'));
    }

    try {
      final res = await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final body = res.data;
      final data = (body is Map<String, dynamic>) ? body['data'] : null;
      if (data is! Map) {
        return const Left(Failure('Invalid register response'));
      }

      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      final userJson = data['user'] as Map<String, dynamic>?;

      if (accessToken == null || userJson == null) {
        return const Left(Failure('Missing token or user data'));
      }

      final user = UserModel.fromJson(userJson);

      await _box.write(AppConstants.keyAccessToken, accessToken);
      if (refreshToken != null) {
        await _box.write(AppConstants.keyRefreshToken, refreshToken);
      }
      await _box.write(AppConstants.keyUser, user.toJson());

      return Right(user);
    } on DioException catch (e) {
      final msg =
          e.response?.data is Map && (e.response!.data['message'] is String)
              ? e.response!.data['message'] as String
              : e.message ?? 'Unable to register';
      return Left(Failure(msg));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<void> logout() async {
    await _box.remove(AppConstants.keyAccessToken);
    await _box.remove(AppConstants.keyRefreshToken);
    await _box.remove(AppConstants.keyUser);
  }

  bool get isLoggedIn => accessToken != null;

  String? get accessToken => _box.read<String>(AppConstants.keyAccessToken);

  UserModel? get currentUser {
    final json = _box.read(AppConstants.keyUser);
    if (json == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(json));
  }
}
