import 'package:flutter/material.dart';
import '../../models/bundle_model.dart';
import '../../../../core/theme/design_tokens.dart';

class ProductBundleSection extends StatelessWidget {
  final ProductBundle bundle;
  final VoidCallback onAddToCart;

  const ProductBundleSection({
    Key? key,
    required this.bundle,
    required this.onAddToCart,
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
            'APROVEITE E LEVE TAMBÉM',
            style: TextStyle(
              fontSize: fontSectionTitle, // FASE 2: 16px
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: spaceM), // FASE 2: 12px
          // Container do bundle
          Container(
            padding: const EdgeInsets.all(spaceM), // FASE 2: caixa padding 12px
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(cardRadius), // FASE 2: 12px
              border: Border.all(color: Colors.grey[700]!, width: 1),
            ),
            child: Column(
              children: [
                // Produtos lado a lado
                Row(
                  children: [
                    // Produto principal
                    Expanded(
                      child: _buildProductImage(bundle.mainProduct),
                    ),
                    const SizedBox(width: 16),
                    // Ícone de +
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6200EE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Produto complementar
                    Expanded(
                      child: _buildProductImage(bundle.complementaryProduct),
                    ),
                  ],
                ),
                const SizedBox(height: spaceM), // FASE 2: 12px
                // Botão de compra
                SizedBox(
                  width: double.infinity,
                  height: bundleButtonHeight, // FASE 2: botão do combo height 44px
                  child: ElevatedButton(
                    onPressed: onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6200EE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(cardRadius), // FASE 2: 12px
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Ganhe ${bundle.bundleDiscountPercent.toStringAsFixed(0)}% de desconto no combo',
                      style: const TextStyle(
                        fontSize: fontBody, // FASE 2: 14px
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: spaceM), // FASE 2: 12px
                // Preços
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'De R\$ ${bundle.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'por R\$ ${bundle.discountedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(BundleProduct product) {
    return Column(
      children: [
        Container(
          height: bundleImageSize, // FASE 2: imagem size reduzida 110x110
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(spaceS), // FASE 2: 8px
          ),
          child: Center(
            child: Icon(
              Icons.image,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
        ),
        const SizedBox(height: spaceS), // FASE 2: 8px
        Text(
          product.name,
          style: TextStyle(
            fontSize: fontSmall, // FASE 2: 12px
            color: Colors.grey[300],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
