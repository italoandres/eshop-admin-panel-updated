import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/router/app_router.dart';
import '../../core/services/services_locator.dart';
import '../../domain/entities/product/product.dart';
import '../../domain/entities/product/progressive_discount_rule.dart';
import '../../domain/usecases/discount_rule/get_discount_rule_usecase.dart';

class ProductCard extends StatefulWidget {
  final Product? product;
  final Function? onFavoriteToggle;
  final Function? onClick;
  const ProductCard({
    super.key,
    this.product,
    this.onFavoriteToggle,
    this.onClick,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  ProgressiveDiscountRule? _discountRule;
  bool _loadingDiscount = true;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _loadDiscountRule();
    }
  }

  Future<void> _loadDiscountRule() async {
    try {
      print('[ProductCard] Buscando desconto para produto: ${widget.product!.id}');
      final useCase = sl<GetDiscountRuleUseCase>();
      final result = await useCase(widget.product!.id);
      
      result.fold(
        (failure) {
          print('[ProductCard] ERRO ao buscar desconto: $failure');
          if (mounted) {
            setState(() {
              _loadingDiscount = false;
            });
          }
        },
        (rule) {
          print('[ProductCard] Regra encontrada: ${rule?.name}');
          print('[ProductCard] Regra ativa? ${rule?.isCurrentlyActive()}');
          if (mounted) {
            if (rule != null && rule.isCurrentlyActive()) {
              print('[ProductCard] ✅ DESCONTO ATIVO! ${rule.tiers.first.discountPercent}%');
              setState(() {
                _discountRule = rule;
                _loadingDiscount = false;
              });
            } else {
              print('[ProductCard] ❌ Sem desconto ativo');
              setState(() {
                _loadingDiscount = false;
              });
            }
          }
        },
      );
    } catch (e) {
      print('[ProductCard] EXCEÇÃO: $e');
      if (mounted) {
        setState(() {
          _loadingDiscount = false;
        });
      }
    }
  }

  double _calculateDiscountedPrice() {
    if (_discountRule == null || widget.product == null) return 0;
    
    final originalPrice = widget.product!.priceTags.first.price;
    final firstTier = _discountRule!.tiers.first;
    final discountPercent = firstTier.discountPercent / 100;
    final discountedPrice = originalPrice * (1 - discountPercent);
    
    return discountedPrice;
  }

  @override
  Widget build(BuildContext context) {
    return widget.product == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade100,
            highlightColor: Colors.white,
            child: buildBody(context),
          )
        : buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.product != null) {
          Navigator.of(context)
              .pushNamed(AppRouter.productDetails, arguments: widget.product);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(
                color: Theme.of(context).shadowColor.withOpacity(0.15),
              ),
            ),
            child: Stack(
              children: [
                // Imagem do produto
                widget.product == null
                    ? Material(
                        child: GridTile(
                          footer: Container(),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Container(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                      )
                    : Hero(
                        tag: widget.product!.id,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.product!.images.first,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.white,
                              child: Container(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error)),
                          ),
                        ),
                      ),
                
                // Badge de desconto progressivo
                if (!_loadingDiscount && _discountRule != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF45a049)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.card_giftcard,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_discountRule!.tiers.first.quantity}x ${_discountRule!.tiers.first.discountPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )),
          Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: SizedBox(
                height: 18,
                child: widget.product == null
                    ? Container(
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    : Text(
                        widget.product!.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
              )),
          // Preço com desconto
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Row(
              children: [
                // Badge de desconto
                if (!_loadingDiscount && _discountRule != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D67),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${_discountRule!.tiers.first.discountPercent.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (!_loadingDiscount && _discountRule != null)
                  const SizedBox(width: 6),
                
                // Preço com desconto
                SizedBox(
                  height: 18,
                  child: widget.product == null
                      ? Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )
                      : Text(
                          r'R$ ' + (_discountRule != null 
                              ? _calculateDiscountedPrice().toStringAsFixed(2)
                              : widget.product!.priceTags.first.price.toStringAsFixed(2)),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _discountRule != null ? const Color(0xFFFF4D67) : Colors.black,
                          ),
                        ),
                ),
                
                // Preço original riscado
                if (!_loadingDiscount && _discountRule != null && widget.product != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      r'R$ ' + widget.product!.priceTags.first.price.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Linha de desconto progressivo
          if (!_loadingDiscount && _discountRule != null && _discountRule!.tiers.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.card_giftcard,
                    size: 14,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Escolha outro produto e ganhe ${_discountRule!.tiers[1].discountPercent.toStringAsFixed(0)}% de desconto',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
