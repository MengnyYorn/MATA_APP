// lib/data/repositories/order_repository.dart

import 'package:dartz/dartz.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../providers/mock_data.dart';
import 'auth_repository.dart';

class OrderRepository {
  final _orders = <OrderModel>[...MockData.orders];

  Future<Either<Failure, List<OrderModel>>> getMyOrders() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Right(List.from(_orders));
  }

  Future<Either<Failure, OrderModel>> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final order = _orders.firstWhere((o) => o.id == id,
        orElse: () => throw Exception('Not found'));
    return Right(order);
  }

  Future<Either<Failure, OrderModel>> placeOrder(
      List<CartItemModel> items) async {
    await Future.delayed(const Duration(seconds: 1));

    final order = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      customerName: 'Guest User',
      date: DateTime.now().toString().substring(0, 10),
      total: items.fold(0, (sum, i) => sum + i.subtotal),
      status: OrderStatus.pending,
      itemCount: items.fold(0, (sum, i) => sum + i.quantity),
    );

    _orders.insert(0, order);
    return Right(order);
  }
}
