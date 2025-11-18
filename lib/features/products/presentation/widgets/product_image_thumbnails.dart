import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product_image_model.dart';
import '../controllers/product_gallery_controller.dart';

/// Widget de galeria de miniaturas das imagens do produto
/// Exibido abaixo da imagem principal, mostra todas as fotos da variação selecionada
class ProductImageThumbnails extends ConsumerWidget {
  final List<ProductImageModel> images;
  final int currentIndex;
  final Function(int) onThumbnailTap;

  const ProductImageThumbnails({
    Key? key,
    required this.images,
    required this.currentIndex,
    required this.onThumbnailTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () => onThumbnailTap(index),
            child: Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey[300]!,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _buildThumbnailImage(image),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnailImage(ProductImageModel image) {
    // Se tiver URL válida, tentar carregar a imagem
    if (image.displayUrl.isNotEmpty &&
        (image.displayUrl.startsWith('http://') ||
         image.displayUrl.startsWith('https://'))) {
      return Image.network(
        image.displayUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
      );
    }

    // Placeholder para imagens mock ou inválidas
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.grey[400],
          size: 32,
        ),
      ),
    );
  }
}
