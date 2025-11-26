import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/shimmer_product_card.dart';

class ProductSection extends ConsumerWidget {
  final String title;
  final FutureProvider<List<dynamic>> productsProvider;
  final String sectionRoute;

  const ProductSection({
    super.key,
    required this.title,
    required this.productsProvider,
    required this.sectionRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Column(
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: productsAsync.when(
            data: (products) => _buildProductList(products, context),
            loading: () => _buildShimmerLoading(),
            error: (error, stack) => _buildErrorState(error, ref),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              context.push(sectionRoute);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Ver mais'),
                Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<dynamic> products, BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Container(
          width: 160,
          margin: const EdgeInsets.only(right: 12),
          child: ProductCard(
            product: products[index],
            useFixedHeight: true,
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 12),
          child: const ShimmerProductCard(useFixedHeight: true),
        );
      },
    );
  }

  Widget _buildErrorState(Object error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'Erro ao carregar produtos',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                ref.invalidate(productsProvider);
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Tentar Novamente'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhum produto disponível',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
