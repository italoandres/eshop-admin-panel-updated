class RelatedProduct {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final bool isFavorite;

  RelatedProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.isFavorite = false,
  });

  RelatedProduct copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    double? originalPrice,
    bool? isFavorite,
  }) {
    return RelatedProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountPercent {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }
}
