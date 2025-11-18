import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/product_customer_protection.dart';
import '../widgets/product_progressive_discount_banner.dart';
import '../widgets/product_description_modal.dart';
import '../widgets/product_main_image.dart';
import '../widgets/product_image_thumbnails.dart';
import '../widgets/size_guide_button.dart';
import '../widgets/size_guide_modal.dart';
import '../widgets/product_highlights_section.dart';
import '../widgets/product_size_chip.dart';
import '../controllers/product_gallery_controller.dart';
import '../../models/product_image_model.dart';
import '../../../shipping/presentation/widgets/shipping_options_modal.dart';
import '../../../reviews/presentation/widgets/reviews_modal.dart';
import '../../../bundles/presentation/widgets/product_bundle_section.dart';
import '../../../bundles/models/bundle_model.dart';
import '../../../related_products/presentation/widgets/related_products_section.dart';
import '../../../related_products/models/related_product_model.dart';
import '../../../../core/theme/design_tokens.dart';
import 'package:go_router/go_router.dart';
import '../../../cart/presentation/notifiers/cart_notifier.dart';

class ProductDetailPage extends ConsumerStatefulWidget{
  final String productId;

  const ProductDetailPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  // Estado do componente
  int _currentPhotoIndex = 0;
  String _selectedColor = 'Azul';
  int _selectedColorIndex = 1;
  String _selectedSize = 'M';
  bool hasCouponBanner = true;

  // Dados mock
  final mockRating = 4.66;
  final mockRatingCount = 671;
  final mockRecommendationPercent = 0.95;
  final mockReviews = const [
    {'user': 'Edson', 'date': '17 de nov de 2025', 'comment': 'Ótimo produto. Recomendo!', 'rating': 5},
    {'user': 'Kelly', 'date': '12 de nov de 2025', 'comment': 'Top demais!', 'rating': 5},
    {'user': 'Carlos', 'date': '10 de nov de 2025', 'comment': 'Superou minhas expectativas!', 'rating': 5},
    {'user': 'Ana', 'date': '8 de nov de 2025', 'comment': 'Produto de qualidade. Vale a pena.', 'rating': 4},
  ];

  // Dados de preço e desconto
  final double mockOriginalPrice = 50.00;
  final double? mockProgressiveDiscountPercent = 48.0; // 48% de desconto

  // Mock data para características em destaque
  // FASE 2: Testado com múltiplos cenários
  // ✅ CENÁRIO 1: Vários highlights (5 items) - comportamento padrão
  final List<String> mockHighlights = [
    'Material respirável',
    'Tecnologia Dry-Fit',
    'Acabamento premium',
    'Resistente a lavagens',
    'Fit anatômico',
  ];

  // ✅ CENÁRIO 2: Um único highlight (descomente para testar)
  // final List<String> mockHighlights = ['Material respirável'];

  // ✅ CENÁRIO 3: Sem highlights (descomente para testar - seção não aparece)
  // final List<String> mockHighlights = [];

  // Mock data para bundle
  late final ProductBundle mockBundle;

  // Mock data para produtos relacionados
  List<RelatedProduct> mockRelatedProducts = [
    RelatedProduct(
      id: '1',
      name: 'Camisa Nike Dri-FIT Park VII',
      imageUrl: '',
      price: 89.90,
      originalPrice: 129.90,
      isFavorite: false,
    ),
    RelatedProduct(
      id: '2',
      name: 'Camisa Adidas Squadra 21',
      imageUrl: '',
      price: 79.90,
      isFavorite: true,
    ),
    RelatedProduct(
      id: '3',
      name: 'Camisa Puma TeamGOAL 23',
      imageUrl: '',
      price: 99.90,
      originalPrice: 149.90,
      isFavorite: false,
    ),
    RelatedProduct(
      id: '4',
      name: 'Camisa Penalty Matís IX',
      imageUrl: '',
      price: 69.90,
      isFavorite: false,
    ),
  ];

  // Mock data para variações de cor com imagens
  late final List<ProductVariation> mockVariations;

  @override
  void initState() {
    super.initState();

    // Inicializar variações de cor com imagens
    mockVariations = [
      ProductVariation(
        id: 'var_vermelho',
        color: 'Vermelho',
        colorHex: '#E53935',
        images: [
          const ProductImageModel(
            id: 'img_vermelho_1',
            url: '',
            order: 0,
            alt: 'Camisa Umbro Vermelha - Vista Frontal',
          ),
          const ProductImageModel(
            id: 'img_vermelho_2',
            url: '',
            order: 1,
            alt: 'Camisa Umbro Vermelha - Vista Traseira',
          ),
          const ProductImageModel(
            id: 'img_vermelho_3',
            url: '',
            order: 2,
            alt: 'Camisa Umbro Vermelha - Detalhe',
          ),
        ],
      ),
      ProductVariation(
        id: 'var_azul',
        color: 'Azul',
        colorHex: '#1E88E5',
        images: [
          const ProductImageModel(
            id: 'img_azul_1',
            url: '',
            order: 0,
            alt: 'Camisa Umbro Azul - Vista Frontal',
          ),
          const ProductImageModel(
            id: 'img_azul_2',
            url: '',
            order: 1,
            alt: 'Camisa Umbro Azul - Vista Traseira',
          ),
          const ProductImageModel(
            id: 'img_azul_3',
            url: '',
            order: 2,
            alt: 'Camisa Umbro Azul - Detalhe',
          ),
          const ProductImageModel(
            id: 'img_azul_4',
            url: '',
            order: 3,
            alt: 'Camisa Umbro Azul - Vista Lateral',
          ),
        ],
      ),
      ProductVariation(
        id: 'var_verde',
        color: 'Verde',
        colorHex: '#43A047',
        images: [
          const ProductImageModel(
            id: 'img_verde_1',
            url: '',
            order: 0,
            alt: 'Camisa Umbro Verde - Vista Frontal',
          ),
          const ProductImageModel(
            id: 'img_verde_2',
            url: '',
            order: 1,
            alt: 'Camisa Umbro Verde - Vista Traseira',
          ),
        ],
      ),
      ProductVariation(
        id: 'var_preto',
        color: 'Preto',
        colorHex: '#212121',
        images: [
          const ProductImageModel(
            id: 'img_preto_1',
            url: '',
            order: 0,
            alt: 'Camisa Umbro Preta - Vista Frontal',
          ),
          const ProductImageModel(
            id: 'img_preto_2',
            url: '',
            order: 1,
            alt: 'Camisa Umbro Preta - Vista Traseira',
          ),
          const ProductImageModel(
            id: 'img_preto_3',
            url: '',
            order: 2,
            alt: 'Camisa Umbro Preta - Detalhe',
          ),
        ],
      ),
      ProductVariation(
        id: 'var_branco',
        color: 'Branco',
        colorHex: '#FFFFFF',
        images: [
          const ProductImageModel(
            id: 'img_branco_1',
            url: '',
            order: 0,
            alt: 'Camisa Umbro Branca - Vista Frontal',
          ),
          const ProductImageModel(
            id: 'img_branco_2',
            url: '',
            order: 1,
            alt: 'Camisa Umbro Branca - Vista Traseira',
          ),
        ],
      ),
      ProductVariation(
        id: 'var_cinza',
        color: 'Cinza',
        colorHex: '#757575',
        images: [
          const ProductImageModel(
            id: 'img_cinza_1',
            url: '',
            order: 0,
            alt: 'Camisa Umbro Cinza - Vista Frontal',
          ),
          const ProductImageModel(
            id: 'img_cinza_2',
            url: '',
            order: 1,
            alt: 'Camisa Umbro Cinza - Vista Traseira',
          ),
          const ProductImageModel(
            id: 'img_cinza_3',
            url: '',
            order: 2,
            alt: 'Camisa Umbro Cinza - Detalhe',
          ),
        ],
      ),
    ];

    // Inicializar galeria com a cor Azul (índice 1)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productGalleryControllerProvider.notifier).initializeGallery(
            images: mockVariations[_selectedColorIndex].images,
            variationId: mockVariations[_selectedColorIndex].id,
          );
    });

    // Inicializar bundle com desconto progressivo
    mockBundle = ProductBundle(
      mainProduct: BundleProduct(
        id: 'main',
        name: 'Camisa Umbro TWR Striker',
        imageUrl: '',
        price: 26.00, // Preço com desconto progressivo
      ),
      complementaryProduct: BundleProduct(
        id: 'comp',
        name: 'Meião Umbro TWR',
        imageUrl: '',
        price: 19.90,
      ),
      bundleDiscountPercent: 15.0, // 15% de desconto adicional no combo
      totalPrice: 45.90, // 26.00 + 19.90
      discountedPrice: 39.02, // 45.90 - 15%
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // Conteúdo scrollável
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Espaço para o header fixo (barra lilás 40px + barra progressiva 40px = 80px)
                SizedBox(height: MediaQuery.of(context).padding.top + 80),

                // Banner de cupom (opcional) - scrollável
                if (hasCouponBanner) _buildCouponBanner(),

                // Carousel de fotos
                _buildPhotoCarousel(),

                // Avaliação
                _buildRating(),

                // Título + WhatsApp + Favorito
                _buildTitleSection(),

                // Preço
                _buildPriceSection(),

                // Tarja de desconto progressivo (se houver)
                if (mockProgressiveDiscountPercent != null && mockProgressiveDiscountPercent! > 0)
                  ProductProgressiveDiscountBanner(
                    discountPercent: mockProgressiveDiscountPercent!,
                  ),

                Divider(height: spaceL, thickness: 1, color: Colors.grey[800]), // FASE 1: 16px section spacing

                // Seletor de cor
                _buildColorSelector(),

                // Seletor de tamanho
                _buildSizeSelector(),

                // Alerta de estoque baixo
                _buildStockAlert(),

                const SizedBox(height: spaceL), // FASE 1: 16px section spacing

                // Seção: Prazo de entrega
                _buildDeliverySection(),

                Divider(height: spaceL, thickness: 1, color: Colors.grey[800]), // FASE 1: 16px section spacing

                // Seção: Proteção do Cliente
                const ProductCustomerProtectionSection(),

                Divider(height: spaceL, thickness: 1, color: Colors.grey[800]), // FASE 1: 16px section spacing

                // Seção: Descrição do Produto (accordion)
                _buildDescriptionSection(),

                Divider(height: spaceL, thickness: 1, color: Colors.grey[800]), // FASE 1: 16px section spacing

                // FASE 1: Seção de Características em Destaque
                ProductHighlightsSection(
                  highlights: mockHighlights,
                ),

                // Seção: Avaliação do produto
                _buildRatingOverview(),

                const SizedBox(height: spaceL), // FASE 1: 16px section spacing

                // Seção: Recomendações
                _buildRecommendationSection(),

                const SizedBox(height: spaceL), // FASE 1: 16px section spacing

                // Botão: Mostrar todas avaliações
                _buildShowAllReviewsButton(),

                const SizedBox(height: spaceL), // FASE 1: 16px section spacing

                // Seção: Comentários mais recentes
                _buildRecentReviews(),

                const SizedBox(height: spaceXL), // FASE 1: 20px section spacing

                // Seção: Bundle de produtos
                ProductBundleSection(
                  bundle: mockBundle,
                  onAddToCart: _handleBundleAddToCart,
                ),

                // Seção: Produtos relacionados
                RelatedProductsSection(
                  products: mockRelatedProducts,
                  onProductTap: _handleRelatedProductTap,
                  onToggleFavorite: _handleToggleFavorite,
                ),

                const SizedBox(height: 120), // Espaço para o botão fixo
              ],
            ),
          ),

          // Header fixo no topo
          _buildFixedHeader(),

          // Botão adicionar ao carrinho fixo no rodapé
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildAddToCartButton(),
          ),
        ],
      ),
    );
  }

  // Header fixo (topo - barra lilás 40px + barra de desconto progressivo)
  Widget _buildFixedHeader() {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container LILÁS - 40px de altura
          Container(
            height: statusBarHeight + 40,
            color: const Color(0xFF6200EE),
            child: Column(
              children: [
                SizedBox(height: statusBarHeight),
                // Área lilás com botões (40px visíveis)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botão Fechar (X)
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        // Botão Carrinho
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                              onPressed: () {
                                context.push('/cart');
                              },
                            ),
                            // Badge com quantidade
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final itemCount = ref.watch(cartItemCountProvider);
                                  if (itemCount == 0) return const SizedBox.shrink();

                                  return Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      '$itemCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Barra de desconto progressivo PRETA - colada abaixo da barra lilás (fixa)
          _buildProgressBar(),
        ],
      ),
    );
  }

  // Barra de promoção progressiva
  Widget _buildProgressBar() {
    return Container(
      height: 40,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          // Etapa 1
          _buildProgressStep(
            label: '25%',
            isActive: true,
            isCompleted: false,
          ),
          // Linha conectora
          Expanded(
            child: Container(
              height: 2,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // Etapa 2
          _buildProgressStep(
            label: '40%',
            isActive: false,
            isCompleted: false,
          ),
          // Linha conectora
          Expanded(
            child: Container(
              height: 2,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // Etapa 3
          _buildProgressStep(
            label: '65%',
            isActive: false,
            isCompleted: false,
          ),
          // Linha conectora
          Expanded(
            child: Container(
              height: 2,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // Prêmio final
          _buildProgressStep(
            label: 'R\$ 20',
            isActive: false,
            isCompleted: false,
            icon: Icons.card_giftcard,
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para etapas do progresso
  Widget _buildProgressStep({
    required String label,
    required bool isActive,
    required bool isCompleted,
    IconData? icon,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive
                ? Colors.white
                : Colors.white.withOpacity(0.3),
          ),
          child: icon != null
              ? Icon(
                  icon,
                  size: 16,
                  color: isCompleted || isActive
                      ? Theme.of(context).primaryColor
                      : Colors.white.withOpacity(0.7),
                )
              : Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isCompleted || isActive
                          ? Theme.of(context).primaryColor
                          : Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  // Banner de cupom
  Widget _buildCouponBanner() {
    return Container(
      height: 50,
      width: double.infinity,
      color: const Color(0xFFFFEB3B), // Amarelo
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            '+10% OFF',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9C27B0),
            ),
          ),
          const SizedBox(width: 8),
          const Flexible(
            child: Text(
              'na primeira compra! cupom',
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PRIMEIRA10',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Galeria de fotos do produto (imagem principal + thumbnails)
  Widget _buildPhotoCarousel() {
    final galleryState = ref.watch(productGalleryControllerProvider);

    // Se não há imagens ainda, mostrar placeholder
    if (galleryState.images.isEmpty) {
      return Column(
        children: [
          Container(
            height: 400,
            color: Colors.grey[200],
            child: Center(
              child: Icon(Icons.image, size: 100, color: Colors.grey[400]),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        // Imagem principal com botão de expandir
        ProductMainImage(
          image: galleryState.currentImage,
          allImages: galleryState.images,
          currentIndex: galleryState.currentImageIndex,
        ),

        // Galeria de miniaturas
        ProductImageThumbnails(
          images: galleryState.images,
          currentIndex: galleryState.currentImageIndex,
          onThumbnailTap: (index) {
            ref.read(productGalleryControllerProvider.notifier).selectImage(index);
          },
        ),
      ],
    );
  }

  // Avaliação (clicável - abre modal de reviews)
  Widget _buildRating() {
    return GestureDetector(
      onTap: () => _showReviewsModal(),
      child: Padding(
        padding: const EdgeInsets.all(spaceM), // FASE 1: 12px
        child: Row(
          children: [
            const Text(
              '4.66',
              style: TextStyle(
                fontSize: fontBody, // FASE 1: 14px
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: spaceS), // FASE 1: 8px
            Row(
              children: List.generate(5, (index) {
                return const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: starSize, // FASE 1: 16px
                );
              }),
            ),
            const SizedBox(width: spaceS), // FASE 1: 8px
            Text(
              'Baseado em 671 avaliações',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: fontSmall, // FASE 1: 12px
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Título + WhatsApp + Favorito
  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(spaceL, spaceM, spaceL, 0), // FASE 1: horizontal 16px, top 12px
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Text(
              'Camisa Umbro TWR Striker Masculina',
              style: TextStyle(
                fontSize: fontTitleXL, // FASE 1: 24px
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: spaceM), // FASE 1: 12px
          // Botão WhatsApp
          GestureDetector(
            onTap: () {
              // TODO: Abrir WhatsApp
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrindo WhatsApp...')),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF25D366),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.message,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Botão Favoritar
          GestureDetector(
            onTap: () {
              // TODO: Adicionar aos favoritos
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adicionado aos favoritos!')),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                border: Border.all(color: Colors.grey[700]!),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Preço
  Widget _buildPriceSection() {
    // Cálculo do preço com desconto
    final discountPercent = mockProgressiveDiscountPercent ?? 0;
    final discountedPrice = mockOriginalPrice * (1 - (discountPercent / 100));
    final installmentPrice = discountedPrice / 3;

    return Padding(
      padding: const EdgeInsets.all(spaceL), // FASE 1: 16px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha com badge de desconto e preço original riscado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge de desconto (se houver)
              if (mockProgressiveDiscountPercent != null && mockProgressiveDiscountPercent! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // FASE 1: badges 12px/8px
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(8), // FASE 1: badge radius 8px
                  ),
                  child: Text(
                    '-${mockProgressiveDiscountPercent!.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: fontBody, // FASE 1: 14px
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(width: spaceS), // FASE 1: 8px
              // Preço original riscado
              if (mockProgressiveDiscountPercent != null && mockProgressiveDiscountPercent! > 0)
                Text(
                  'R\$ ${mockOriginalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: fontPriceSmall, // FASE 1: 14px
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey[500],
                  ),
                ),
            ],
          ),
          const SizedBox(height: spaceS), // FASE 1: 8px (gap entre preço e parcelamento)
          // Preço final com desconto
          Text(
            'A partir de',
            style: TextStyle(
              fontSize: fontSmall, // FASE 1: 12px
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: spaceXS), // FASE 1: 4px
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: fontPriceLarge, // FASE 1: 30px
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: spaceS), // FASE 1: 8px
              Text(
                'no Pix',
                style: TextStyle(
                  fontSize: fontBody, // FASE 1: 14px
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: spaceS), // FASE 1: 8px
          // Parcelamento (calculado com base no preço com desconto)
          Text(
            'ou 3x de R\$ ${installmentPrice.toStringAsFixed(2)} sem juros',
            style: TextStyle(
              fontSize: fontPriceSmall, // FASE 1: 14px
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Seletor de cor
  Widget _buildColorSelector() {
    return Padding(
      padding: const EdgeInsets.all(spaceL), // FASE 1: 16px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cor: $_selectedColor',
            style: const TextStyle(
              fontSize: fontSectionTitle, // FASE 1: 16px
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: spaceM), // FASE 1: 12px (margin-top)
          SizedBox(
            height: thumbnailSize, // FASE 1: 56px (mini thumbnail size)
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6, // 6 cores disponíveis
              itemBuilder: (context, index) {
                final isSelected = index == _selectedColorIndex;
                final colors = ['Vermelho', 'Azul', 'Verde', 'Preto', 'Branco', 'Cinza'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                      _selectedColor = colors[index];
                    });

                    // Atualizar imagens da galeria quando trocar de cor
                    ref.read(productGalleryControllerProvider.notifier).updateVariation(
                          images: mockVariations[index].images,
                          variationId: mockVariations[index].id,
                        );
                  },
                  child: Container(
                    width: thumbnailSize, // FASE 1: 56px
                    margin: const EdgeInsets.only(right: spaceS), // FASE 1: gap 8px
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[700]!,
                        width: isSelected ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.image, color: Colors.grey[600]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Seletor de tamanho
  Widget _buildSizeSelector() {
    return Padding(
      padding: const EdgeInsets.all(spaceL), // FASE 1: 16px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tamanho',
            style: TextStyle(
              fontSize: fontSectionTitle, // FASE 1: 16px
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: spaceM), // FASE 1: 12px
          // FASE 2: Chips dinâmicos com largura automática
          Wrap(
            spacing: spaceS, // 8px gap horizontal
            runSpacing: spaceS, // 8px gap vertical
            children: ['P', 'M', 'G', 'GG', 'EGG'].map((size) {
              final isSelected = size == _selectedSize;
              final isAvailable = size != 'EGG'; // EGG indisponível

              // FASE 2: Substituído Container por ProductSizeChip
              // ✅ Largura automática (sem minWidth)
              // ✅ Padding: 14px horizontal, 10px vertical
              // ✅ Border radius: 8px
              // ✅ Lógica mantida idêntica
              return ProductSizeChip(
                size: size,
                isSelected: isSelected,
                isAvailable: isAvailable,
                onTap: () {
                  setState(() {
                    _selectedSize = size;
                  });
                },
              );
            }).toList(),
          ),
          // FASE 1: Botão Guia de Tamanhos (logo abaixo da grade)
          const SizedBox(height: spaceS), // 8px gap
          SizeGuideButton(
            onTap: () => _showSizeGuideModal(),
          ),
        ],
      ),
    );
  }

  // Alerta de estoque baixo
  Widget _buildStockAlert() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0), // Laranja claro
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF57C00),
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Só 7 unidades em estoque!',
            style: TextStyle(
              color: Color(0xFFF57C00),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Botão adicionar ao carrinho
  Widget _buildAddToCartButton() {
    return Container(
      padding: const EdgeInsets.all(spaceL), // FASE 1: bottom margin 16px
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Adicionar produto ao carrinho
          ref.read(cartProvider.notifier).addItem(
            productId: widget.productId,
            name: 'Vestido Midi Floral Premium',
            imageUrl: 'https://picsum.photos/400/400?random=1',
            price: 189.90,
            originalPrice: 249.90,
            size: _selectedSize,
            color: _selectedColor,
          );

          // Mostrar confirmação
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Produto adicionado ao carrinho!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'VER CARRINHO',
                textColor: Colors.white,
                onPressed: () {
                  context.push('/cart');
                },
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          minimumSize: const Size(double.infinity, primaryButtonHeight), // FASE 1: 50px
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius), // FASE 1: 12px
          ),
          elevation: 0,
        ),
        child: const Text(
          'Adicionar ao Carrinho',
          style: TextStyle(
            fontSize: fontSectionTitle, // FASE 1: 16px
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // (A) Seção: Prazo de entrega
  Widget _buildDeliverySection() {
    return Padding(
      padding: const EdgeInsets.all(spaceL), // FASE 1: section padding 16px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prazo de entrega',
            style: TextStyle(
              fontSize: fontSmall, // FASE 1: 12px
              fontWeight: FontWeight.w600,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: spaceS), // FASE 1: 8px
          Text(
            'Chega dia 25 de novembro para o CEP 01310-100, se você finalizar o pedido com a opção de entrega Normal.',
            style: TextStyle(
              fontSize: fontBody, // FASE 1: 14px
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: spaceM), // FASE 1: 12px
          Wrap(
            spacing: spaceXL, // FASE 1: 20px
            runSpacing: spaceS, // FASE 1: 8px
            children: [
              GestureDetector(
                onTap: () => _showShippingOptionsModal(),
                child: Text(
                  'Alterar CEP',
                  style: TextStyle(
                    fontSize: fontBody, // FASE 1: 14px
                    color: const Color(0xFF6200EE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showShippingOptionsModal(),
                child: Text(
                  'Ver outras formas de entrega',
                  style: TextStyle(
                    fontSize: fontBody, // FASE 1: 14px
                    color: const Color(0xFF6200EE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // (B) Seção: Descrição do Produto (botão que abre modal)
  Widget _buildDescriptionSection() {
    return InkWell(
      onTap: () => _showProductDescriptionModal(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: spaceL, vertical: spaceM), // FASE 1: 16px/12px
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Descrição do Produto',
              style: TextStyle(
                fontSize: fontSectionTitle, // FASE 1: 16px
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // (C) Seção: Avaliação do produto
  Widget _buildRatingOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceL), // FASE 1: 16px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Avaliação do produto',
            style: TextStyle(
              fontSize: fontSectionTitle, // FASE 1: 16px
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: spaceXS), // FASE 1: 4px
          Text(
            'Avaliações dos clientes',
            style: TextStyle(
              fontSize: fontSmall, // FASE 1: 12px
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: spaceL), // FASE 1: 16px
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                mockRating.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < mockRating.floor()
                            ? Icons.star
                            : (index < mockRating ? Icons.star_half : Icons.star_border),
                        color: Colors.amber,
                        size: 24,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Baseado em $mockRatingCount avaliações.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // (D) Seção: Recomendações
  Widget _buildRecommendationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${(mockRecommendationPercent * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              tween: Tween<double>(
                begin: 0,
                end: mockRecommendationPercent,
              ),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6200EE)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dos clientes recomendam esse produto.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  // (E) Botão: Mostrar todas avaliações (abre modal de reviews)
  Widget _buildShowAllReviewsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _showReviewsModal(),
        child: Row(
          children: [
            Text(
              'Mostrar todas avaliações',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF6200EE),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF6200EE),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // (F) Seção: Comentários mais recentes (scroll horizontal)
  Widget _buildRecentReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: spaceL), // FASE 2: 16px
          child: Text(
            'Comentários mais recentes',
            style: const TextStyle(
              fontSize: fontSectionTitle, // FASE 2: 16px
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: spaceL), // FASE 2: 16px
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: spaceL), // FASE 2: 16px
            itemCount: mockReviews.length,
            itemBuilder: (context, index) {
              final review = mockReviews[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: spaceS), // FASE 2: card margin-bottom 8px
                padding: const EdgeInsets.all(spaceM), // FASE 2: card padding 12px
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(cardRadius), // FASE 2: 12px
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estrelas
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < (review['rating'] as int)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: starSize, // FASE 2: star size 16px
                        );
                      }),
                    ),
                    const SizedBox(height: spaceS), // FASE 2: 8px
                    // Nome do cliente
                    Text(
                      review['user'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Data
                    Text(
                      review['date'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Comentário
                    Expanded(
                      child: Text(
                        review['comment'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[300],
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Método para abrir modal de opções de frete
  void _showShippingOptionsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ShippingOptionsModal(),
    );
  }

  // Método para abrir modal de descrição do produto
  void _showProductDescriptionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProductDescriptionModal(),
    );
  }

  // Método para abrir modal de avaliações (reviews)
  void _showReviewsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReviewsModal(),
    );
  }

  // Método para abrir modal do Guia de Tamanhos (FASE 1)
  void _showSizeGuideModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SizeGuideModal(),
    );
  }

  // Método para adicionar bundle ao carrinho
  void _handleBundleAddToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bundle adicionado ao carrinho! Economia de R\$ ${mockBundle.savedAmount.toStringAsFixed(2)}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Método para navegar para produto relacionado
  void _handleRelatedProductTap(String productId) {
    // TODO: Navigate to product detail for the related product
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrindo produto $productId...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Método para alternar favorito em produtos relacionados
  void _handleToggleFavorite(String productId) {
    setState(() {
      final index = mockRelatedProducts.indexWhere((p) => p.id == productId);
      if (index != -1) {
        mockRelatedProducts[index] = mockRelatedProducts[index].copyWith(
          isFavorite: !mockRelatedProducts[index].isFavorite,
        );
      }
    });
  }
}
