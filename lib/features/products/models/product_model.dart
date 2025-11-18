/// Modelo de produto
///
/// FASE 1: Adicionado suporte para Guia de Tamanhos
/// - sizeGuideType: Tipo do guia ('shoe', 'clothes', ou null)
/// - sizeGuideContent: URL da imagem ou conteúdo HTML customizado
///
/// FASE 1: Adicionado suporte para Características em Destaque
/// - highlights: Lista de características destacadas do produto
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String? imageUrl;

  // FASE 1: Campos do Guia de Tamanhos
  /// Tipo do guia de tamanhos
  /// - 'shoe': Guia de calçados
  /// - 'clothes': Guia de roupas
  /// - null: Produto sem guia (botão não aparece)
  final String? sizeGuideType;

  /// Conteúdo customizado do guia
  /// - URL da imagem da tabela de medidas
  /// - Conteúdo HTML (a ser implementado na Fase 2)
  /// - Se null, usa o guia padrão baseado no sizeGuideType
  final String? sizeGuideContent;

  // FASE 1: Características em Destaque
  /// Lista de características em destaque do produto
  /// - Máximo 40 caracteres por item
  /// - Renderizado como chips na página de detalhes
  /// - Se vazio, seção não aparece
  final List<String> highlights;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.sizeGuideType,
    this.sizeGuideContent,
    this.highlights = const [],
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    String? sizeGuideType,
    String? sizeGuideContent,
    List<String>? highlights,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      sizeGuideType: sizeGuideType ?? this.sizeGuideType,
      sizeGuideContent: sizeGuideContent ?? this.sizeGuideContent,
      highlights: highlights ?? this.highlights,
    );
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountPercent {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  /// Verifica se o produto tem guia de tamanhos
  bool get hasSizeGuide => sizeGuideType != null;

  /// Verifica se deve usar guia customizado
  bool get hasCustomSizeGuide => sizeGuideContent != null;

  /// Verifica se o produto tem características em destaque
  bool get hasHighlights => highlights.isNotEmpty;

  /// Converte para JSON (para API/Admin)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'sizeGuideType': sizeGuideType,
      'sizeGuideContent': sizeGuideContent,
      'highlights': highlights,
    };
  }

  /// Cria instância a partir do JSON (para API/Admin)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      imageUrl: json['imageUrl'] as String?,
      sizeGuideType: json['sizeGuideType'] as String?,
      sizeGuideContent: json['sizeGuideContent'] as String?,
      highlights: json['highlights'] != null
          ? List<String>.from(json['highlights'] as List)
          : const [],
    );
  }
}
