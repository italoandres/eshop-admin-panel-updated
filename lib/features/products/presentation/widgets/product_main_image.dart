import 'package:flutter/material.dart';
import '../../models/product_image_model.dart';
import 'product_image_fullscreen_modal.dart';

/// Widget da imagem principal do produto com botão de expandir
class ProductMainImage extends StatelessWidget {
  final ProductImageModel image;
  final List<ProductImageModel> allImages;
  final int currentIndex;

  const ProductMainImage({
    Key? key,
    required this.image,
    required this.allImages,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // Imagem principal
          Positioned.fill(
            child: _buildMainImage(),
          ),

          // Botão de expandir (canto inferior direito)
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _openFullscreen(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fullscreen,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImage() {
    // Se tiver URL válida, tentar carregar a imagem
    if (image.url.isNotEmpty &&
        (image.url.startsWith('http://') || image.url.startsWith('https://'))) {
      return Image.network(
        image.url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
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
          size: 100,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductImageFullscreenModal(
          images: allImages,
          initialIndex: currentIndex,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
