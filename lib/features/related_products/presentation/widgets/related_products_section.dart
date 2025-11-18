import 'package:flutter/material.dart';
import '../../models/related_product_model.dart';
import '../../../../core/theme/design_tokens.dart';

class RelatedProductsSection extends StatelessWidget {
  final List<RelatedProduct> products;
  final Function(String productId) onProductTap;
  final Function(String productId) onToggleFavorite;

  const RelatedProductsSection({
    Key? key,
    required this.products,
    required this.onProductTap,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceL, vertical: spaceXL), // FASE 2: 16px/20px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'RELACIONADOS AO SEU INTERESSE',
            style: TextStyle(
              fontSize: fontSectionTitle, // FASE 2: product name font-size 16px
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: spaceM), // FASE 2: 12px
          // Grid de produtos
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: spaceS, // FASE 2: gap horizontal 8px
              mainAxisSpacing: spaceS, // FASE 2: gap vertical 8px
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(RelatedProduct product) {
    return GestureDetector(
      onTap: () => onProductTap(product.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(cardRadius), // FASE 2: 12px
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(cardRadius), // FASE 2: 12px
                      topRight: Radius.circular(cardRadius), // FASE 2: 12px
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                // Botão de favorito
                Positioned(
                  top: spaceS, // FASE 2: 8px
                  right: spaceS, // FASE 2: 8px
                  child: GestureDetector(
                    onTap: () => onToggleFavorite(product.id),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        product.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: product.isFavorite ? Colors.red : Colors.grey[600],
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // Badge de desconto (se houver)
                if (product.hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${product.discountPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Informações do produto
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(spaceS), // FASE 2: card padding 8px
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome do produto
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: fontBody, // FASE 2: product name font-size 14px
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[100],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Preço original (se houver desconto)
                    if (product.hasDiscount)
                      Text(
                        'R\$ ${product.originalPrice!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: fontSmall, // FASE 2: 12px
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    // Preço atual
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: fontSectionTitle, // FASE 2: price font-size 16px
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
