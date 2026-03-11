// lib/modules/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/product_card.dart';
import '../../routes/app_routes.dart';
import '../cart/cart_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: controller.loadProducts,
        child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            titleSpacing: 24,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  'Hello, ${controller.userName} 👋',
                  style: AppTextStyles.bodySmall,
                )),
                const Text('MATA', style: AppTextStyles.headline3),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () => Get.toNamed(AppRoutes.products),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: controller.goToCart,
                  ),
                  Obx(() => cart.totalItems > 0
                      ? Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${cart.totalItems}',
                                style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()),
                ],
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: controller.goToProfile,
                    child: const Row(children: [
                      Icon(Icons.person_outline_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Profile'),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: controller.goToOrders,
                    child: const Row(children: [
                      Icon(Icons.receipt_long_outlined, size: 20),
                      SizedBox(width: 12),
                      Text('My Orders'),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: controller.logout,
                    child: const Row(children: [
                      Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
                      SizedBox(width: 12),
                      Text('Logout', style: TextStyle(color: AppColors.error)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ── Hero Banner ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: _HeroBanner(),
          ),

          // ── Category Chips ───────────────────────────────────────
          SliverToBoxAdapter(
            child: _CategoryRow(),
          ),

          // ── Section Title ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Curated for You', style: AppTextStyles.headline3),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.products),
                    child: const Text('View All',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
          ),

          // ── Product Grid ─────────────────────────────────────────
          Obx(() {
            if (controller.isLoading.value) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => _ShimmerCard(),
                    childCount: 4,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ProductCard(
                    product: controller.products[i],
                    onTap: () => controller.goToProduct(controller.products[i].id),
                  ),
                  childCount: controller.products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
              ),
            );
          }),
        ],
      ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&q=80&w=1000',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NEW COLLECTION',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Ethereal\nSummer',
                      style: AppTextStyles.headline1
                          .copyWith(color: Colors.white, height: 1.1)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.products),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(120, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('SHOP NOW',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: AppConstants.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = AppConstants.categories[i];
          return Obx(() {
            final selected = controller.selectedCat.value == cat;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  cat,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: selected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmer,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.shimmer,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
