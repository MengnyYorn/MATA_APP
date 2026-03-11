// lib/data/models/order_model.dart

class OrderModel {
  final String id;
  final String customerName;
  final String date;
  final double total;
  final OrderStatus status;
  final int itemCount;

  const OrderModel({
    required this.id,
    required this.customerName,
    required this.date,
    required this.total,
    required this.status,
    required this.itemCount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'].toString(),
    customerName: json['customerName'] ?? '',
    date: json['date'] ?? json['createdAt'] ?? '',
    total: (json['total'] as num).toDouble(),
    status: OrderStatus.fromString(json['status'] ?? 'Pending'),
    itemCount: json['itemCount'] ?? json['items'] ?? 0,
  );
}

enum OrderStatus {
  pending,
  shipped,
  delivered,
  cancelled;

  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'shipped':    return OrderStatus.shipped;
      case 'delivered':  return OrderStatus.delivered;
      case 'cancelled':  return OrderStatus.cancelled;
      default:           return OrderStatus.pending;
    }
  }

  String get label {
    switch (this) {
      case pending:   return 'Pending';
      case shipped:   return 'Shipped';
      case delivered: return 'Delivered';
      case cancelled: return 'Cancelled';
    }
  }
}
