// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommended_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendedProductModel _$RecommendedProductModelFromJson(
    Map<String, dynamic> json) {
  return _RecommendedProductModel.fromJson(json);
}

/// @nodoc
mixin _$RecommendedProductModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double? get originalPrice => throw _privateConstructorUsedError;

  /// Serializes this RecommendedProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendedProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendedProductModelCopyWith<RecommendedProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendedProductModelCopyWith<$Res> {
  factory $RecommendedProductModelCopyWith(RecommendedProductModel value,
          $Res Function(RecommendedProductModel) then) =
      _$RecommendedProductModelCopyWithImpl<$Res, RecommendedProductModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String imageUrl,
      double price,
      double? originalPrice});
}

/// @nodoc
class _$RecommendedProductModelCopyWithImpl<$Res,
        $Val extends RecommendedProductModel>
    implements $RecommendedProductModelCopyWith<$Res> {
  _$RecommendedProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendedProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? price = null,
    Object? originalPrice = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendedProductModelImplCopyWith<$Res>
    implements $RecommendedProductModelCopyWith<$Res> {
  factory _$$RecommendedProductModelImplCopyWith(
          _$RecommendedProductModelImpl value,
          $Res Function(_$RecommendedProductModelImpl) then) =
      __$$RecommendedProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String imageUrl,
      double price,
      double? originalPrice});
}

/// @nodoc
class __$$RecommendedProductModelImplCopyWithImpl<$Res>
    extends _$RecommendedProductModelCopyWithImpl<$Res,
        _$RecommendedProductModelImpl>
    implements _$$RecommendedProductModelImplCopyWith<$Res> {
  __$$RecommendedProductModelImplCopyWithImpl(
      _$RecommendedProductModelImpl _value,
      $Res Function(_$RecommendedProductModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendedProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? price = null,
    Object? originalPrice = freezed,
  }) {
    return _then(_$RecommendedProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendedProductModelImpl implements _RecommendedProductModel {
  const _$RecommendedProductModelImpl(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.price,
      this.originalPrice});

  factory _$RecommendedProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendedProductModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String imageUrl;
  @override
  final double price;
  @override
  final double? originalPrice;

  @override
  String toString() {
    return 'RecommendedProductModel(id: $id, name: $name, imageUrl: $imageUrl, price: $price, originalPrice: $originalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendedProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, imageUrl, price, originalPrice);

  /// Create a copy of RecommendedProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendedProductModelImplCopyWith<_$RecommendedProductModelImpl>
      get copyWith => __$$RecommendedProductModelImplCopyWithImpl<
          _$RecommendedProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendedProductModelImplToJson(
      this,
    );
  }
}

abstract class _RecommendedProductModel implements RecommendedProductModel {
  const factory _RecommendedProductModel(
      {required final String id,
      required final String name,
      required final String imageUrl,
      required final double price,
      final double? originalPrice}) = _$RecommendedProductModelImpl;

  factory _RecommendedProductModel.fromJson(Map<String, dynamic> json) =
      _$RecommendedProductModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get imageUrl;
  @override
  double get price;
  @override
  double? get originalPrice;

  /// Create a copy of RecommendedProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendedProductModelImplCopyWith<_$RecommendedProductModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
