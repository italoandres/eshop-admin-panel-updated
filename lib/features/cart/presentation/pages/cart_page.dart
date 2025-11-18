import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/cart_item_model.dart';
import '../../models/recommended_product_model.dart';
import '../widgets/price_change_alert.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/progressive_discount_box.dart';
import '../widgets/cart_recommendations.dart';
import '../widgets/cart_summary.dart';
import '../notifiers/cart_notifier.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> with SingleTickerProviderStateMixin {

  final List<RecommendedProductModel> _recommendedProducts = [
    const RecommendedProductModel(
      id: 'rec-1',
      name: 'Cinto de Couro Premium',
      imageUrl: 'https://picsum.photos/400/400?random=10',
      price: 79.90,
      originalPrice: 99.90,
    ),
    const RecommendedProductModel(
      id: 'rec-2',
      name: 'Bolsa Tote Minimalista',
      imageUrl: 'https://picsum.photos/400/400?random=11',
      price: 149.90,
    ),
    const RecommendedProductModel(
      id: 'rec-3',
      name: 'Óculos de Sol Retrô',
      imageUrl: 'https://picsum.photos/400/400?random=12',
      price: 129.90,
      originalPrice: 179.90,
    ),
    const RecommendedProductModel(
      id: 'rec-4',
      name: 'Sandália Plataforma',
      imageUrl: 'https://picsum.photos/400/400?random=13',
      price: 159.90,
    ),
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Obter dados do carrinho via Riverpod
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final discountPercent = ref.watch(cartDiscountPercentProvider);
    final discount = ref.watch(cartDiscountAmountProvider);

    // Verificar se há produtos com mudança de preço
    final hasChangedPrice = cartItems.any((item) => item.priceChanged == true);
    final changedPriceItem = hasChangedPrice
        ? cartItems.firstWhere((item) => item.priceChanged == true)
        : null;

    // Calcular próximo desconto
    final nextDiscountPercent = _getNextDiscountPercent(discountPercent);
    final nextDiscountThreshold = _getNextDiscountThreshold(discountPercent);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Sacola (${cartItems.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[800],
            height: 1,
          ),
        ),
      ),
      body: cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(
        cartItems: cartItems,
        hasChangedPrice: hasChangedPrice,
        changedPriceItem: changedPriceItem,
        subtotal: subtotal,
        discount: discount,
        discountPercent: discountPercent,
        nextDiscountPercent: nextDiscountPercent,
        nextDiscountThreshold: nextDiscountThreshold,
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Sua sacola está vazia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione produtos para começar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'CONTINUAR COMPRANDO',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent({
    required List<CartItemModel> cartItems,
    required bool hasChangedPrice,
    required CartItemModel? changedPriceItem,
    required double subtotal,
    required double discount,
    required int discountPercent,
    required int nextDiscountPercent,
    required double nextDiscountThreshold,
  }) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Alerta de mudança de preço
            if (hasChangedPrice && changedPriceItem != null)
              SliverToBoxAdapter(
                child: PriceChangeAlert(
                  productName: changedPriceItem.name,
                ),
              ),

            // Lista de produtos no carrinho
            SliverPadding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = cartItems[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: CartItemCard(
                        item: item,
                        onIncrement: () => _incrementQuantity(item.id),
                        onDecrement: () => _decrementQuantity(item.id),
                        onRemove: () => _removeItem(item.id),
                      ),
                    );
                  },
                  childCount: cartItems.length,
                ),
              ),
            ),

            // Caixa de desconto progressivo (sempre mostrar para incentivar)
            SliverToBoxAdapter(
              child: ProgressiveDiscountBox(
                currentTotal: subtotal,
                currentDiscountPercent: discountPercent,
                nextDiscountPercent: nextDiscountPercent,
                nextDiscountThreshold: nextDiscountThreshold,
              ),
            ),

            // Recomendações
            SliverToBoxAdapter(
              child: CartRecommendations(
                products: _recommendedProducts,
                onAddProduct: _addRecommendedProduct,
              ),
            ),

            // Espaço para o resumo fixo
            const SliverToBoxAdapter(
              child: SizedBox(height: 200),
            ),
          ],
        ),

        // Resumo fixo no rodapé
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CartSummary(
            subtotal: subtotal,
            discount: discount,
            discountPercent: discountPercent,
            onContinue: _handleContinue,
            isLoading: _isLoading,
          ),
        ),
      ],
    );
  }

  // Métodos auxiliares
  int _getNextDiscountPercent(int currentPercent) {
    if (currentPercent >= 80) return 80;
    if (currentPercent >= 65) return 80;
    if (currentPercent >= 40) return 65;
    if (currentPercent >= 25) return 40;
    return 25;
  }

  double _getNextDiscountThreshold(int currentPercent) {
    if (currentPercent >= 80) return 1000;
    if (currentPercent >= 65) return 1000;
    if (currentPercent >= 40) return 700;
    if (currentPercent >= 25) return 400;
    return 200;
  }

  void _incrementQuantity(String itemId) {
    ref.read(cartProvider.notifier).incrementQuantity(itemId);
  }

  void _decrementQuantity(String itemId) {
    ref.read(cartProvider.notifier).decrementQuantity(itemId);
  }

  void _removeItem(String itemId) {
    ref.read(cartProvider.notifier).removeItem(itemId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item removido da sacola'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addRecommendedProduct(String productId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produto adicionado à sacola!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  void _handleContinue() {
    setState(() => _isLoading = true);

    // Simular processamento
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prosseguindo para o checkout...'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
}
