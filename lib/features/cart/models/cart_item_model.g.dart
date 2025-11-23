// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemModelImpl _$$CartItemModelImplFromJson(Map<String, dynamic> json) =>
    _$CartItemModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      size: json['size'] as String,
      color: json['color'] as String,
      quantity: (json['quantity'] as num).toInt(),
      priceChanged: json['priceChanged'] as bool?,
      previousPrice: (json['previousPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'size': instance.size,
      'color': instance.color,
      'quantity': instance.quantity,
      'priceChanged': instance.priceChanged,
      'previousPrice': instance.previousPrice,
    };
