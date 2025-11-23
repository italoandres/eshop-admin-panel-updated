// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendedProductModelImpl _$$RecommendedProductModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendedProductModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$RecommendedProductModelImplToJson(
        _$RecommendedProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
    };
