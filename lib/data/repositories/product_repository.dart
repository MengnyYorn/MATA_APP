// lib/data/repositories/product_repository.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import '../models/product_model.dart';
import 'auth_repository.dart';
import '../../core/constants/app_constants.dart';

class ProductRepository {
  ProductRepository({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: _resolveBaseUrl(AppConstants.baseUrl),
    connectTimeout: AppConstants.connectTimeout,
    receiveTimeout: AppConstants.receiveTimeout,
  ));

  final Dio _dio;

  static String _resolveBaseUrl(String baseUrl) {
    // Android emulator can't reach host's "localhost" directly.
    // Use 10.0.2.2 to access the host machine.
    if (Platform.isAndroid && baseUrl.contains('localhost')) {
      return baseUrl.replaceFirst('localhost', '10.0.2.2');
    }
    return baseUrl;
  }

  Future<Either<Failure, List<ProductModel>>> getProducts({
    String? category,
    String? search,
  }) async {
    try {
      final res = await _dio.get(
        '/products',
        queryParameters: {
          if (category != null && category.isNotEmpty && category != 'All')
            'category': category,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final body = res.data;
      final data = (body is Map<String, dynamic>) ? body['data'] : null;
      if (data is! List) {
        return Left(const Failure('Invalid products response'));
      }

      return Right(
        data
            .whereType<Map>()
            .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(Failure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, ProductModel>> getProductById(String id) async {
    try {
      final res = await _dio.get('/products/$id');
      final body = res.data;
      final data = (body is Map<String, dynamic>) ? body['data'] : null;
      if (data is! Map) {
        return Left(const Failure('Invalid product response'));
      }
      return Right(ProductModel.fromJson(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 404) return Left(const Failure('Product not found'));
      return Left(Failure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
