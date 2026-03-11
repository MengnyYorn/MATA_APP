// lib/data/repositories/wishlist_repository.dart

import 'package:get_storage/get_storage.dart';

import '../../core/constants/app_constants.dart';

class WishlistRepository {
  final _box = GetStorage();

  List<String> get _ids =>
      List<String>.from(_box.read<List>(AppConstants.keyWishlist) ?? const []);

  bool isFavorite(String productId) => _ids.contains(productId);

  Future<bool> toggle(String productId) async {
    final ids = _ids;
    final exists = ids.contains(productId);
    if (exists) {
      ids.remove(productId);
    } else {
      ids.add(productId);
    }
    await _box.write(AppConstants.keyWishlist, ids);
    return !exists;
  }
}

