import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String title;
  final String price;
  final bool useFixedHeight;

  const ProductCard({
    super.key,
    required this.productId,
    required this.title,
    required this.price,
    this.useFixedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: useFixedHeight ? Clip.none : Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push('/product/$productId');
        },
        borderRadius: useFixedHeight ? BorderRadius.circular(16) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            _buildImage(),
            // Informações do produto
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
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

  Widget _buildImage() {
    if (useFixedHeight) {
      // Versão da home: altura fixa com bordas arredondadas
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.image,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      // Versão da lista: AspectRatio 1:1
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: Colors.grey[200],
          child: const Center(
            child: Icon(
              Icons.image,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
  }
}
