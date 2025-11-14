import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop/core/constant/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../domain/entities/cart/cart_item.dart';
import '../../../../../domain/entities/product/price_tag.dart';
import '../../../../../domain/entities/product/product.dart';
import '../../../../../domain/entities/product/progressive_discount_rule.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/usecases/discount_rule/get_discount_rule_usecase.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/input_form_button.dart';
import '../../widgets/product/discount_banner_card.dart';
import '../../widgets/product/price_section.dart';
import '../../widgets/product/promotional_banner.dart';
import '../../widgets/product/rating_component.dart';
import '../../widgets/product/shipping_section.dart';
import '../../widgets/product/product_variants_section.dart';
import '../../widgets/product/customer_protection_card.dart';
import '../../widgets/modals/customer_protection_modal.dart';
import '../../widgets/modals/product_variants_modal.dart';
import '../../widgets/modals/progressive_discount_modal.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;
  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _currentIndex = 0;
  late PriceTag _selectedPriceTag;
  ProgressiveDiscountRule? _discountRule;
  bool _loadingDiscount = true;
  final Map<String, MemoryImage> _imageCache = {};

  @override
  void initState() {
    _selectedPriceTag = widget.product.priceTags.first;
    _loadDiscountRule();
    _preloadImages();
    super.initState();
  }

  // Pré-carrega todas as imagens base64
  Future<void> _preloadImages() async {
    for (final imageUrl in widget.product.images) {
      if (imageUrl.startsWith('data:image')) {
        try {
          final base64String = imageUrl.split(',').last;
          final bytes = const Base64Decoder().convert(base64String);
          _imageCache[imageUrl] = MemoryImage(bytes);
        } catch (e) {
          // Ignora erros de decodificação
        }
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadDiscountRule() async {
    try {
      final useCase = sl<GetDiscountRuleUseCase>();
      final result = await useCase(widget.product.id);
      
      result.fold(
        (failure) => _setLoadingComplete(),
        (rule) => _setLoadingComplete(
          rule: rule?.isCurrentlyActive() == true ? rule : null,
        ),
      );
    } catch (e) {
      _setLoadingComplete();
    }
  }

  void _setLoadingComplete({ProgressiveDiscountRule? rule}) {
    setState(() {
      _discountRule = rule;
      _loadingDiscount = false;
    });
  }

  // Calcula o preço com desconto do primeiro nível
  num _calculateDiscountedPrice() {
    if (_discountRule == null || _discountRule!.tiers.isEmpty) {
      return widget.product.currentPrice;
    }
    
    final firstTier = _discountRule!.tiers.first;
    return firstTier.calculateFinalPrice(widget.product.currentPrice);
  }

  // Calcula a porcentagem de desconto
  int _calculateDiscountPercentage() {
    if (_discountRule == null || _discountRule!.tiers.isEmpty) {
      return widget.product.discountPercentage ?? 0;
    }
    
    final firstTier = _discountRule!.tiers.first;
    return firstTier.discountPercent.toInt();
  }

  // Getter para verificar se tem desconto ativo
  bool get _hasActiveDiscount => !_loadingDiscount && _discountRule != null;

  Widget _buildProductImage(String imageUrl) {
    // Verifica se é base64
    if (imageUrl.startsWith('data:image')) {
      // Usa a imagem do cache se disponível
      final cachedImage = _imageCache[imageUrl];
      if (cachedImage != null) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: cachedImage,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                Colors.grey.shade50.withOpacity(0.25),
                BlendMode.softLight,
              ),
            ),
          ),
        );
      }
      
      // Se não está no cache, mostra placeholder
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // Se não é base64, usa CachedNetworkImage
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              Colors.grey.shade50.withOpacity(0.25),
              BlendMode.softLight,
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> _showVariantsModal() async {
    final selectedVariant = await ProductVariantsModal.show(
      context: context,
      variants: widget.product.priceTags,
      selectedVariant: _selectedPriceTag,
    );

    if (selectedVariant != null) {
      setState(() {
        _selectedPriceTag = selectedVariant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
      ),
      body: ListView(
        children: [
          // Carrossel de imagens
          Padding(
            padding: const EdgeInsets.only(top: kPaddingMedium),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).width,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: double.infinity,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: widget.product.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Hero(
                        tag: widget.product.id,
                        child: _buildProductImage(image),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),

          // Indicadores do carrossel
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.center,
              child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: widget.product.images.length,
                effect: ScrollingDotsEffect(
                    dotColor: Colors.grey.shade300,
                    maxVisibleDots: 7,
                    activeDotColor: Colors.grey,
                    dotHeight: 6,
                    dotWidth: 6,
                    activeDotScale: 1.1,
                    spacing: 6),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Seção de preço
          PriceSection(
            currentPrice: _hasActiveDiscount 
                ? _calculateDiscountedPrice() 
                : widget.product.currentPrice,
            originalPrice: widget.product.currentPrice,
            discountPercentage: _hasActiveDiscount
                ? _calculateDiscountPercentage()
                : widget.product.discountPercentage,
            installment: widget.product.installmentInfo,
          ),

          // Banner promocional (se houver)
          if (widget.product.activePromotion != null)
            PromotionalBanner(
              promotion: widget.product.activePromotion!,
              onTap: () {
                // TODO: Navegar para detalhes da promoção
                debugPrint('Abrir promoção: ${widget.product.activePromotion!.title}');
              },
            ),

          // Banner de desconto progressivo (se houver)
          if (_hasActiveDiscount)
            DiscountBannerCard(
              discountRule: _discountRule!,
              productPrice: widget.product.currentPrice,
              onTap: () {
                ProgressiveDiscountModal.show(
                  context,
                  _discountRule!,
                  1,
                  widget.product.currentPrice,
                );
              },
            ),

          // Título do produto
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              widget.product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Rating e vendas
          if (widget.product.rating > 0 || widget.product.soldCount > 0)
            RatingComponent(
              rating: widget.product.rating,
              reviewCount: widget.product.reviewCount,
              soldCount: widget.product.soldCount,
            ),

          // Frete (se houver)
          if (widget.product.shippingInfo != null)
            ShippingSection(
              shippingInfo: widget.product.shippingInfo!,
              onTap: () {
                // TODO: Mostrar modal de opções de frete
                debugPrint('Abrir opções de frete');
              },
            ),

          // Variações do produto
          if (widget.product.priceTags.length > 1)
            ProductVariantsSection(
              variants: widget.product.priceTags,
              onTap: _showVariantsModal,
            ),

          // Card de proteção do cliente
          CustomerProtectionCard(
            onTap: () {
              CustomerProtectionModal.show(context);
            },
          ),

          const SizedBox(height: 16),

          // Descrição do produto
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.product.description,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.secondary,
        height: 80 + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10,
          top: 10,
          left: 20,
          right: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  total,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  '\$${_selectedPriceTag.price}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 120,
              child: InputFormButton(
                onClick: () {
                  context.read<CartBloc>().add(AddProduct(
                      cartItem: CartItem(
                          product: widget.product,
                          priceTag: _selectedPriceTag)));
                  // print("test");
                  Navigator.pop(context);
                },
                titleText: addToCart,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            SizedBox(
              width: 90,
              child: InputFormButton(
                onClick: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.orderCheckout, arguments: [
                    CartItem(
                      product: widget.product,
                      priceTag: _selectedPriceTag,
                    )
                  ]);
                },
                titleText: buy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
