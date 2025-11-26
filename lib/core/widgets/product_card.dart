import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool useFixedHeight;

  const ProductCard({
    super.key,
    required this.product,
    this.useFixedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final productId = product['_id'] ?? '';
    final name = product['name'] ?? 'Produto';
    final imageUrl = _getProductImage();
    final priceText = _getProductPrice();

    return GestureDetector(
      onTap: () {
        if (productId.isNotEmpty) {
          context.push('/product/$productId');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            _buildProductImage(imageUrl),
            // Informações do produto
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    priceText,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    if (useFixedHeight) {
      // Versão da home: altura fixa
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Container(
          height: 140,
          width: double.infinity,
          color: Colors.grey[100],
          child: imageUrl != null && imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey[400],
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                )
              : Icon(
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
        ),
      );
    } else {
      // Versão da lista: AspectRatio 1:1
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: Colors.grey[100],
            child: imageUrl != null && imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey[400],
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  )
                : Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
          ),
        ),
      );
    }
  }

  /// Extrai a primeira imagem do produto
  String? _getProductImage() {
    if (product['images'] != null && product['images'] is List) {
      final images = product['images'] as List;
      if (images.isNotEmpty) {
        return images[0] as String?;
      }
    }
    return null;
  }

  /// Extrai e formata o preço do produto
  String _getProductPrice() {
    if (product['priceTags'] != null && product['priceTags'] is List) {
      final priceTags = product['priceTags'] as List;
      if (priceTags.isNotEmpty) {
        final firstTag = priceTags[0] as Map<String, dynamic>;
        final price = firstTag['price'];
        final name = firstTag['name'] ?? '';
        
        if (price != null) {
          final priceValue = price is int ? price.toDouble() : price as double;
          final formattedPrice = priceValue.toStringAsFixed(2).replaceAll('.', ',');
          
          // Se o nome do priceTag indica range, mostrar "A partir de"
          if (name.toLowerCase().contains('partir')) {
            return 'A partir de R\$ $formattedPrice';
          }
          
          return 'R\$ $formattedPrice';
        }
      }
    }
    return 'Preço sob consulta';
  }
}
