// lib/modules/product/detail/product_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import 'product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final p = controller.product.value;
        if (p == null) return const SizedBox();

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                // ── Image ────────────────────────────────────────
                SliverAppBar(
                  expandedHeight: 420,
                  pinned: true,
                  backgroundColor: AppColors.surface,
                  leading: Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            size: 18, color: AppColors.textPrimary),
                        onPressed: Get.back,
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: const Icon(Icons.favorite_border_rounded,
                            color: AppColors.textSecondary, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      imageUrl: p.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ── Info Panel ───────────────────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category + Price row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(p.category.toUpperCase(),
                                  style: AppTextStyles.labelSmall),
                              Text('\$${p.price.toStringAsFixed(2)}',
                                  style: AppTextStyles.priceLarge
                                      .copyWith(color: AppColors.accent)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(p.name, style: AppTextStyles.headline1),

                          // Rating
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ...List.generate(5, (i) => Icon(
                                i < p.rating.floor()
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 16,
                                color: AppColors.warning,
                              )),
                              const SizedBox(width: 6),
                              Text('${p.rating} (${p.reviews} reviews)',
                                  style: AppTextStyles.bodySmall),
                            ],
                          ),

                          const SizedBox(height: 20),
                          Text(p.description,
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary)),

                          // ── Sizes ────────────────────────────────
                          const SizedBox(height: 28),
                          _SectionLabel('Select Size'),
                          const SizedBox(height: 12),
                          Obx(() => Wrap(
                            spacing: 10,
                            children: p.sizes.map((s) {
                              final sel = controller.selectedSize.value == s;
                              return GestureDetector(
                                onTap: () => controller.selectedSize.value = s,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: sel ? AppColors.primary : AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: sel ? AppColors.primary : AppColors.border,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(s,
                                        style: AppTextStyles.labelLarge.copyWith(
                                            color: sel ? Colors.white : AppColors.textSecondary)),
                                  ),
                                ),
                              );
                            }).toList(),
                          )),

                          // ── Colors ───────────────────────────────
                          const SizedBox(height: 24),
                          _SectionLabel('Select Color'),
                          const SizedBox(height: 12),
                          Obx(() => Wrap(
                            spacing: 10,
                            children: p.colors.map((c) {
                              final sel = controller.selectedColor.value == c;
                              return GestureDetector(
                                onTap: () => controller.selectedColor.value = c,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: sel ? AppColors.primary : AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: sel ? AppColors.primary : AppColors.border,
                                    ),
                                  ),
                                  child: Text(c,
                                      style: AppTextStyles.bodySmall.copyWith(
                                          color: sel ? Colors.white : AppColors.textSecondary,
                                          fontWeight: FontWeight.w600)),
                                ),
                              );
                            }).toList(),
                          )),

                          // ── Quantity ─────────────────────────────
                          const SizedBox(height: 24),
                          _SectionLabel('Quantity'),
                          const SizedBox(height: 12),
                          Obx(() => Row(
                            children: [
                              _QtyButton(
                                icon: Icons.remove,
                                onTap: controller.decrementQty,
                              ),
                              const SizedBox(width: 20),
                              Text('${controller.quantity.value}',
                                  style: AppTextStyles.headline3),
                              const SizedBox(width: 20),
                              _QtyButton(
                                icon: Icons.add,
                                onTap: controller.incrementQty,
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Sticky Bottom Bar ─────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.favorite_border_rounded,
                          color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: 'ADD TO CART',
                        icon: Icons.shopping_bag_outlined,
                        onPressed: controller.addToCart,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(letterSpacing: 2),
      );
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
