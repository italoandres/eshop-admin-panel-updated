import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product_image_model.dart';

/// Estado da galeria de imagens do produto
class ProductGalleryState {
  final List<ProductImageModel> images;
  final int currentImageIndex;
  final String selectedVariationId;
  final bool isFullscreenOpen;

  const ProductGalleryState({
    required this.images,
    required this.currentImageIndex,
    required this.selectedVariationId,
    this.isFullscreenOpen = false,
  });

  ProductGalleryState copyWith({
    List<ProductImageModel>? images,
    int? currentImageIndex,
    String? selectedVariationId,
    bool? isFullscreenOpen,
  }) {
    return ProductGalleryState(
      images: images ?? this.images,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
      selectedVariationId: selectedVariationId ?? this.selectedVariationId,
      isFullscreenOpen: isFullscreenOpen ?? this.isFullscreenOpen,
    );
  }

  ProductImageModel get currentImage => images[currentImageIndex];
}

/// Controller para gerenciar estado da galeria de imagens do produto
class ProductGalleryController extends StateNotifier<ProductGalleryState> {
  ProductGalleryController()
      : super(const ProductGalleryState(
          images: [],
          currentImageIndex: 0,
          selectedVariationId: '',
        ));

  /// Inicializar galeria com imagens de uma variação
  void initializeGallery({
    required List<ProductImageModel> images,
    required String variationId,
  }) {
    state = ProductGalleryState(
      images: images,
      currentImageIndex: 0,
      selectedVariationId: variationId,
    );
  }

  /// Atualizar imagens quando trocar de variação/cor
  void updateVariation({
    required List<ProductImageModel> images,
    required String variationId,
  }) {
    state = state.copyWith(
      images: images,
      currentImageIndex: 0,
      selectedVariationId: variationId,
    );
  }

  /// Selecionar uma imagem específica (ao clicar na thumbnail)
  void selectImage(int index) {
    print('🎯 selectImage called - Index: $index, Current: ${state.currentImageIndex}');
    if (index >= 0 && index < state.images.length) {
      state = state.copyWith(currentImageIndex: index);
      print('✅ State updated - New index: ${state.currentImageIndex}');
    } else {
      print('❌ Invalid index: $index (total images: ${state.images.length})');
    }
  }

  /// Navegar para próxima imagem
  void nextImage() {
    if (state.currentImageIndex < state.images.length - 1) {
      state = state.copyWith(currentImageIndex: state.currentImageIndex + 1);
    }
  }

  /// Navegar para imagem anterior
  void previousImage() {
    if (state.currentImageIndex > 0) {
      state = state.copyWith(currentImageIndex: state.currentImageIndex - 1);
    }
  }

  /// Abrir/fechar fullscreen
  void toggleFullscreen() {
    state = state.copyWith(isFullscreenOpen: !state.isFullscreenOpen);
  }

  void openFullscreen() {
    state = state.copyWith(isFullscreenOpen: true);
  }

  void closeFullscreen() {
    state = state.copyWith(isFullscreenOpen: false);
  }
}

/// Provider para o controller da galeria
final productGalleryControllerProvider =
    StateNotifierProvider.autoDispose<ProductGalleryController, ProductGalleryState>(
  (ref) => ProductGalleryController(),
);
