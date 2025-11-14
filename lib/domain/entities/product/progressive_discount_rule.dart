import 'package:equatable/equatable.dart';

class DiscountTier extends Equatable {
  final int quantity;
  final double discountPercent;

  const DiscountTier({
    required this.quantity,
    required this.discountPercent,
  });

  double calculateDiscount(num originalPrice) {
    return originalPrice * (discountPercent / 100);
  }

  num calculateFinalPrice(num originalPrice) {
    return originalPrice - calculateDiscount(originalPrice);
  }

  @override
  List<Object?> get props => [quantity, discountPercent];

  factory DiscountTier.fromJson(Map<String, dynamic> json) {
    return DiscountTier(
      quantity: json['quantity'] as int,
      discountPercent: (json['discountPercent'] as num).toDouble(),
    );
  }
}

class ProgressiveDiscountRule extends Equatable {
  final String id;
  final String? productId; // Agora é nullable para regras globais
  final String name;
  final String description;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<DiscountTier> tiers;

  const ProgressiveDiscountRule({
    required this.id,
    this.productId, // Opcional
    required this.name,
    required this.description,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.tiers,
  });

  /// Retorna tier aplicável baseado na quantidade
  DiscountTier? getApplicableTier(int quantity) {
    final eligibleTiers = tiers
        .where((tier) => quantity >= tier.quantity)
        .toList()
      ..sort((a, b) => b.quantity.compareTo(a.quantity));

    return eligibleTiers.isNotEmpty ? eligibleTiers.first : null;
  }

  /// Retorna próximo tier disponível
  DiscountTier? getNextTier(int currentQuantity) {
    final nextTiers = tiers
        .where((tier) => tier.quantity > currentQuantity)
        .toList()
      ..sort((a, b) => a.quantity.compareTo(b.quantity));

    return nextTiers.isNotEmpty ? nextTiers.first : null;
  }

  /// Verifica se promoção está ativa no momento
  bool isCurrentlyActive() {
    if (!isActive) return false;

    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;

    return true;
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        name,
        description,
        isActive,
        startDate,
        endDate,
        tiers,
      ];

  factory ProgressiveDiscountRule.fromJson(Map<String, dynamic> json) {
    return ProgressiveDiscountRule(
      id: json['_id'] as String,
      productId: json['productId'] as String?, // Nullable
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      isActive: json['isActive'] as bool,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      tiers: (json['tiers'] as List)
          .map((tier) => DiscountTier.fromJson(tier as Map<String, dynamic>))
          .toList(),
    );
  }
}
