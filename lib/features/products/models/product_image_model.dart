/// Model para representar imagens do produto
class ProductImageModel {
  final String id;
  final String url;
  final String? thumbnailUrl;
  final int order;
  final String? alt;

  const ProductImageModel({
    required this.id,
    required this.url,
    this.thumbnailUrl,
    required this.order,
    this.alt,
  });

  String get displayUrl => thumbnailUrl ?? url;

  ProductImageModel copyWith({
    String? id,
    String? url,
    String? thumbnailUrl,
    int? order,
    String? alt,
  }) {
    return ProductImageModel(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      order: order ?? this.order,
      alt: alt ?? this.alt,
    );
  }

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      order: json['order'] as int? ?? 0,
      alt: json['alt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'order': order,
      'alt': alt,
    };
  }
}

/// Model para representar uma variação de produto com suas imagens
class ProductVariation {
  final String id;
  final String color;
  final String colorHex;
  final List<ProductImageModel> images;

  const ProductVariation({
    required this.id,
    required this.color,
    required this.colorHex,
    required this.images,
  });

  ProductVariation copyWith({
    String? id,
    String? color,
    String? colorHex,
    List<ProductImageModel>? images,
  }) {
    return ProductVariation(
      id: id ?? this.id,
      color: color ?? this.color,
      colorHex: colorHex ?? this.colorHex,
      images: images ?? this.images,
    );
  }

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'] as String,
      color: json['color'] as String,
      colorHex: json['colorHex'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color': color,
      'colorHex': colorHex,
      'images': images.map((e) => e.toJson()).toList(),
    };
  }
}
