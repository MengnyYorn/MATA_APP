// lib/data/models/cart_item_model.dart

import 'package:equatable/equatable.dart';
import 'product_model.dart';

class CartItemModel extends Equatable {
  final ProductModel product;
  final int quantity;
  final String selectedSize;
  final String selectedColor;

  const CartItemModel({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get subtotal => product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) =>
      CartItemModel(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
        selectedSize: selectedSize ?? this.selectedSize,
        selectedColor: selectedColor ?? this.selectedColor,
      );

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
    'selectedSize': selectedSize,
    'selectedColor': selectedColor,
  };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    product: ProductModel.fromJson(json['product']),
    quantity: json['quantity'],
    selectedSize: json['selectedSize'],
    selectedColor: json['selectedColor'],
  );

  // Unique key for identifying cart items
  String get key => '${product.id}_${selectedSize}_$selectedColor';

  @override
  List<Object?> get props => [product.id, selectedSize, selectedColor];
}
