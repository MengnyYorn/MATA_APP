// lib/data/repositories/product_repository.dart

import 'package:dartz/dartz.dart';
import '../models/product_model.dart';
import '../providers/mock_data.dart';
import 'auth_repository.dart';

class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts({
    String? category,
    String? search,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    var products = MockData.products;

    if (category != null && category != 'All') {
      products = products.where((p) => p.category == category).toList();
    }

    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      products = products.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q),
      ).toList();
    }

    return Right(products);
  }

  Future<Either<Failure, ProductModel>> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final product = MockData.products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Not found'),
    );

    return Right(product);
  }
}
