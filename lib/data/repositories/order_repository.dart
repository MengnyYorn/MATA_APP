// lib/data/repositories/order_repository.dart

import 'dart:io' show Platform;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../../core/constants/app_constants.dart';
import 'auth_repository.dart';

class OrderRepository {
  OrderRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _resolveBaseUrl(AppConstants.baseUrl),
                connectTimeout: AppConstants.connectTimeout,
                receiveTimeout: AppConstants.receiveTimeout,
              ),
            );

  final Dio _dio;

  static String _resolveBaseUrl(String baseUrl) {
    if (Platform.isAndroid && baseUrl.contains('localhost')) {
      return baseUrl.replaceFirst('localhost', '10.0.2.2');
    }
    return baseUrl;
  }

  AuthRepository? get _authSafe {
    try {
      return Get.find<AuthRepository>();
    } catch (_) {
      return null;
    }
  }

  Future<Either<Failure, List<OrderModel>>> getMyOrders() async {
    final auth = _authSafe;
    if (auth == null || !auth.isLoggedIn) {
      return const Left(Failure('Please sign in to view your orders.'));
    }

    try {
      final res = await _dio.get(
        '/orders/my',
        options: Options(
          headers: {'Authorization': 'Bearer ${auth.accessToken}'},
        ),
      );
      final body = res.data;
      final data = (body is Map<String, dynamic>) ? body['data'] : null;
      if (data is! List) {
        return const Left(Failure('Invalid orders response'));
      }

      final orders = data
          .whereType<Map>()
          .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return Right(orders);
    } on DioException catch (e) {
      final msg =
          e.response?.data is Map && (e.response!.data['message'] is String)
              ? e.response!.data['message'] as String
              : e.message ?? 'Unable to load orders';
      return Left(Failure(msg));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, OrderModel>> getOrderById(String id) async {
    final auth = _authSafe;
    if (auth == null || !auth.isLoggedIn) {
      return const Left(Failure('Please sign in to view this order.'));
    }

    try {
      final res = await _dio.get(
        '/orders/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${auth.accessToken}'},
        ),
      );
      final body = res.data;
      final data = (body is Map<String, dynamic>) ? body['data'] : null;
      if (data is! Map) {
        return const Left(Failure('Invalid order response'));
      }
      return Right(OrderModel.fromJson(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 404) {
        return const Left(Failure('Order not found'));
      }
      final msg =
          e.response?.data is Map && (e.response!.data['message'] is String)
              ? e.response!.data['message'] as String
              : e.message ?? 'Unable to load order';
      return Left(Failure(msg));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, OrderModel>> placeOrder(
      List<CartItemModel> items) async {
    final auth = _authSafe;
    if (auth == null || !auth.isLoggedIn) {
      return const Left(Failure('Please sign in to place an order.'));
    }
    if (items.isEmpty) {
      return const Left(Failure('Your cart is empty.'));
    }

    final payloadItems = items
        .map((i) => {
              'productId': int.tryParse(i.product.id) ?? 0,
              'productName': i.product.name,
              'price': i.product.price,
              'quantity': i.quantity,
              'selectedSize': i.selectedSize,
              'selectedColor': i.selectedColor,
            })
        .toList();

    try {
      final res = await _dio.post(
        '/orders',
        data: {'items': payloadItems},
        options: Options(
          headers: {'Authorization': 'Bearer ${auth.accessToken}'},
        ),
      );
      final body = res.data;
      final data = (body is Map<String, dynamic>) ? body['data'] : null;
      if (data is! Map) {
        return const Left(Failure('Invalid place-order response'));
      }
      return Right(OrderModel.fromJson(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      final msg =
          e.response?.data is Map && (e.response!.data['message'] is String)
              ? e.response!.data['message'] as String
              : e.message ?? 'Unable to place order';
      return Left(Failure(msg));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
