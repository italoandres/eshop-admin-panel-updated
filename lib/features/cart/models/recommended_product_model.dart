import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommended_product_model.freezed.dart';
part 'recommended_product_model.g.dart';

@freezed
class RecommendedProductModel with _$RecommendedProductModel {
  const factory RecommendedProductModel({
    required String id,
    required String name,
    required String imageUrl,
    required double price,
    double? originalPrice,
  }) = _RecommendedProductModel;

  factory RecommendedProductModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendedProductModelFromJson(json);
}
