// lib/data/models/product_model.dart

import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image;
  final String description;
  final int stock;
  final double rating;
  final int reviews;
  final List<String> sizes;
  final List<String> colors;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
    required this.stock,
    required this.rating,
    required this.reviews,
    required this.sizes,
    required this.colors,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'].toString(),
    name: json['name'] ?? '',
    category: json['category'] ?? '',
    price: (json['price'] as num).toDouble(),
    image: json['image'] ?? '',
    description: json['description'] ?? '',
    stock: json['stock'] ?? 0,
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    reviews: json['reviews'] ?? 0,
    sizes: List<String>.from(json['sizes'] ?? []),
    colors: List<String>.from(json['colors'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'price': price,
    'image': image,
    'description': description,
    'stock': stock,
    'rating': rating,
    'reviews': reviews,
    'sizes': sizes,
    'colors': colors,
  };

  @override
  List<Object?> get props => [id];
}
