import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product_image_model.dart';
import 'product_image_fullscreen_modal.dart';
import '../controllers/product_gallery_controller.dart';

/// Widget da imagem principal do produto com botão de expandir e scroll horizontal
class ProductMainImage extends ConsumerStatefulWidget {
  const ProductMainImage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductMainImage> createState() => _ProductMainImageState();
}

class _ProductMainImageState extends ConsumerState<ProductMainImage> {
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final galleryState = ref.watch(productGalleryControllerProvider);
    
    // Se não tem imagens, mostrar placeholder
    if (galleryState.images.isEmpty) {
      return SizedBox(
        height: 400,
        child: _buildPlaceholder(),
      );
    }
    
    final allImages = galleryState.images;
    final currentIndex = galleryState.currentImageIndex;
    
    // Debug: verificar se o índice está mudando
    print('🖼️ ProductMainImage rebuild - Index: $currentIndex');
    
    // Sincronizar PageController com o estado quando mudar via thumbnail
    if (_pageController.hasClients && _pageController.page?.round() != currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
    
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // PageView com scroll horizontal
          PageView.builder(
            controller: _pageController,
            itemCount: allImages.length,
            onPageChanged: (index) {
              // Atualizar o estado quando o usuário arrastar
              ref.read(productGalleryControllerProvider.notifier).selectImage(index);
            },
            itemBuilder: (context, index) {
              return _buildImagePage(allImages[index], index);
            },
          ),

          // Indicador de página (bolinhas)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                allImages.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),

          // Botão de expandir (canto inferior direito)
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _openFullscreen(context, allImages, currentIndex),
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

  Widget _buildImagePage(ProductImageModel image, int index) {
    final imageUrl = image.url;
    
    // Se tiver URL válida, tentar carregar a imagem
    if (imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
      return Container(
        color: Colors.grey[200], // Fundo cinza para preencher espaços vazios
        child: Image.network(
          imageUrl,
          key: ValueKey('image_$index'),
          fit: BoxFit.contain, // Mantém a imagem completa sem cortar
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
        ),
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

  void _openFullscreen(BuildContext context, List<ProductImageModel> allImages, int currentIndex) {
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
