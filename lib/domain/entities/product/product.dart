import 'package:equatable/equatable.dart';
import 'package:eshop/domain/entities/category/category.dart';
import 'package:eshop/domain/entities/product/price_tag.dart';
import 'package:eshop/domain/entities/product/shipping_info.dart';
import 'package:eshop/domain/entities/product/promotion.dart';
import 'package:eshop/domain/entities/product/installment_info.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<PriceTag> priceTags;
  final List<Category> categories;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Novos campos para tela de detalhes
  final num? originalPrice;
  final int? discountPercentage;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final ShippingInfo? shippingInfo;
  final Promotion? activePromotion;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.priceTags,
    required this.categories,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    this.originalPrice,
    this.discountPercentage,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.soldCount = 0,
    this.shippingInfo,
    this.activePromotion,
  });

  /// Retorna o preço atual (primeiro priceTag)
  num get currentPrice => priceTags.isNotEmpty ? priceTags.first.price : 0;

  /// Retorna informações de parcelamento se o preço for >= 50
  InstallmentInfo? get installmentInfo {
    if (currentPrice >= 50) {
      return InstallmentInfo(
        installments: 5,
        installmentValue: currentPrice / 5,
      );
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        priceTags,
        categories,
        images,
        createdAt,
        updatedAt,
        originalPrice,
        discountPercentage,
        rating,
        reviewCount,
        soldCount,
        shippingInfo,
        activePromotion,
      ];

  /// Factory method para criar produto mock para testes
  factory Product.mock() {
    final now = DateTime.now();
    return Product(
      id: 'mock-product-1',
      name: 'Black Friday TWS M25 Fone De Ouvido bluetooth 5.3 Sem Fio À Prova D\'água 9D Stereo Sp',
      description: 'Fone de ouvido bluetooth de alta qualidade com cancelamento de ruído, resistente à água e som estéreo 9D. Perfeito para esportes e uso diário.',
      priceTags: [
        const PriceTag(id: '1', name: 'Preto', price: 26.09),
        const PriceTag(id: '2', name: 'Branco', price: 26.09),
      ],
      categories: [],
      images: [
        'https://via.placeholder.com/800x800/000000/FFFFFF?text=Produto+1',
        'https://via.placeholder.com/800x800/333333/FFFFFF?text=Produto+2',
      ],
      createdAt: now,
      updatedAt: now,
      originalPrice: 50.00,
      discountPercentage: 48,
      rating: 4.3,
      reviewCount: 336,
      soldCount: 1740,
      shippingInfo: ShippingInfo(
        isFree: true,
        shippingCost: 9.60,
        estimatedDeliveryStart: now.add(const Duration(days: 7)),
        estimatedDeliveryEnd: now.add(const Duration(days: 10)),
      ),
      activePromotion: const Promotion(
        id: 'promo-1',
        title: 'Compre R\$ 200 e ganhe R\$ 20 de desconto',
        description: 'Promoção válida para compras acima de R\$ 200',
        minPurchase: 200,
        discount: 20,
      ),
    );
  }
}
