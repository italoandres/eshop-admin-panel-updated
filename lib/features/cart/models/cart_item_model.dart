import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required String id,
    required String productId,
    required String name,
    required String imageUrl,
    required double price,
    double? originalPrice,
    required String size,
    required String color,
    required int quantity,
    bool? priceChanged,
    double? previousPrice,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}
