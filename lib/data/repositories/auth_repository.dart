// lib/data/repositories/auth_repository.dart

import 'dart:io' show Platform;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  /// Increment when tokens/user in storage change so widgets (e.g. home greeting) can [Obx] rebuild.
  final RxInt sessionRevision = 0.obs;

  void _notifyAuthSessionChanged() => sessionRevision.value++;

  /// Single instance so [logout] can [GoogleSignIn.signOut] and the next
  /// [signIn] shows the account picker instead of reusing the last account.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile'],
    serverClientId: AppConstants.googleServerClientId,
  );

  /// Clears the Google Sign-In session so the next attempt is not stuck in an
  /// ambiguous state (e.g. after backend rejects the token).
  Future<void> _clearGoogleSignInSession() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

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
      _notifyAuthSessionChanged();

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

  Future<Either<Failure, void>> sendLoginOtp({required String email}) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return const Left(Failure('Email is required'));
    }
    try {
      await _dio.post(
        '/auth/login/send-otp',
        data: {'email': trimmed},
      );
      return const Right(null);
    } on DioException catch (e) {
      final msg =
          e.response?.data is Map && (e.response!.data['message'] is String)
              ? e.response!.data['message'] as String
              : e.message ?? 'Unable to send code';
      return Left(Failure(msg));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> loginWithOtp({
    required String email,
    required String otp,
  }) async {
    if (email.trim().isEmpty || otp.trim().isEmpty) {
      return const Left(Failure('Email and code are required'));
    }
    try {
      final res = await _dio.post(
        '/auth/login/otp',
        data: {
          'email': email.trim(),
          'otp': otp.trim(),
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
      _notifyAuthSessionChanged();

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

  Future<Either<Failure, void>> sendRegistrationOtp({
    required String name,
    required String email,
  }) async {
    if (name.isEmpty || email.isEmpty) {
      return const Left(Failure('Name and email are required'));
    }
    try {
      await _dio.post(
        '/auth/register/send-otp',
        data: {
          'name': name,
          'email': email,
        },
      );
      return const Right(null);
    } on DioException catch (e) {
      final msg =
          e.response?.data is Map && (e.response!.data['message'] is String)
              ? e.response!.data['message'] as String
              : e.message ?? 'Unable to send code';
      return Left(Failure(msg));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String password,
    required String otp,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || otp.isEmpty) {
      return const Left(Failure('All fields are required'));
    }

    try {
      final res = await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'otp': otp,
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
      _notifyAuthSessionChanged();

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

  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        await _clearGoogleSignInSession();
        return const Left(Failure('Sign in cancelled'));
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        await _clearGoogleSignInSession();
        return const Left(Failure(
            'No Google ID token. Ensure Web client ID is set and the Android OAuth client (package + SHA-1) exists in Google Cloud.'));
      }

      final res = await _dio.post(
        '/auth/google',
        data: {'idToken': idToken},
      );

      final body = res.data;
      final data = (body is Map<String, dynamic>) ? body['data'] : null;
      if (data is! Map) {
        await _clearGoogleSignInSession();
        return const Left(Failure('Invalid Google auth response'));
      }

      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      final userJson = data['user'] as Map<String, dynamic>?;

      if (accessToken == null || userJson == null) {
        await _clearGoogleSignInSession();
        return const Left(Failure('Missing token or user data'));
      }

      var user = UserModel.fromJson(userJson);
      // Prefer Google profile photo if the API still stores initials only.
      final photo = account.photoUrl;
      if (photo != null &&
          photo.isNotEmpty &&
          !user.hasNetworkAvatar) {
        user = UserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          avatar: photo,
        );
      }

      await _box.write(AppConstants.keyAccessToken, accessToken);
      if (refreshToken != null) {
        await _box.write(AppConstants.keyRefreshToken, refreshToken);
      }
      await _box.write(AppConstants.keyUser, user.toJson());
      _notifyAuthSessionChanged();

      return Right(user);
    } on PlatformException catch (e) {
      await _clearGoogleSignInSession();
      final code = e.code;
      final details = e.message ?? '';
      if (code == 'sign_in_failed' ||
          details.contains('10') ||
          details.contains('DEVELOPER_ERROR')) {
        return const Left(Failure(
            'Google Sign-In setup error (often SHA-1 or package name). Add your debug SHA-1 and com.mata.mata_app to the Android OAuth client in Google Cloud.'));
      }
      return Left(Failure(details.isNotEmpty ? details : 'Google sign-in failed ($code)'));
    } on DioException catch (e) {
      await _clearGoogleSignInSession();
      final msg = _dioErrorMessage(e);
      return Left(Failure(msg));
    } catch (e) {
      await _clearGoogleSignInSession();
      return Left(Failure(e.toString()));
    }
  }

  String _dioErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return e.message ?? 'Request failed';
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Still clear app session if Play Services sign-out fails.
    }
    await _box.remove(AppConstants.keyAccessToken);
    await _box.remove(AppConstants.keyRefreshToken);
    await _box.remove(AppConstants.keyUser);
    _notifyAuthSessionChanged();
  }

  bool get isLoggedIn => accessToken != null;

  String? get accessToken => _box.read<String>(AppConstants.keyAccessToken);

  String? get refreshToken => _box.read<String>(AppConstants.keyRefreshToken);

  /// Uses [refreshToken] to obtain a new access token. Returns false if refresh fails.
  Future<bool> tryRefreshAccessToken() async {
    final rt = refreshToken;
    if (rt == null || rt.isEmpty) return false;
    try {
      final res = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': rt},
      );
      final body = res.data;
      final data = (body is Map<String, dynamic>) ? body['data'] : null;
      if (data is! Map) return false;
      final newAccess = data['accessToken'] as String?;
      final newRefresh = data['refreshToken'] as String?;
      if (newAccess == null) return false;
      await _box.write(AppConstants.keyAccessToken, newAccess);
      if (newRefresh != null) {
        await _box.write(AppConstants.keyRefreshToken, newRefresh);
      }
      final userJson = data['user'] as Map<String, dynamic>?;
      if (userJson != null) {
        await _box.write(AppConstants.keyUser, userJson);
      }
      _notifyAuthSessionChanged();
      return true;
    } catch (_) {
      return false;
    }
  }

  UserModel? get currentUser {
    final json = _box.read(AppConstants.keyUser);
    if (json == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(json));
  }
}
