// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoreConfig _$StoreConfigFromJson(Map<String, dynamic> json) {
  return _StoreConfig.fromJson(json);
}

/// @nodoc
mixin _$StoreConfig {
  String get storeId => throw _privateConstructorUsedError;
  String get apiBaseUrl => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get primaryColor => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get secondaryColor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  bool get showBanners => throw _privateConstructorUsedError;
  bool get showReviews => throw _privateConstructorUsedError;
  bool get showRecommendations => throw _privateConstructorUsedError;
  int get lowStockThreshold => throw _privateConstructorUsedError;

  /// Serializes this StoreConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreConfigCopyWith<StoreConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreConfigCopyWith<$Res> {
  factory $StoreConfigCopyWith(
          StoreConfig value, $Res Function(StoreConfig) then) =
      _$StoreConfigCopyWithImpl<$Res, StoreConfig>;
  @useResult
  $Res call(
      {String storeId,
      String apiBaseUrl,
      String storeName,
      String logoUrl,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      Color primaryColor,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      Color secondaryColor,
      String currency,
      bool showBanners,
      bool showReviews,
      bool showRecommendations,
      int lowStockThreshold});
}

/// @nodoc
class _$StoreConfigCopyWithImpl<$Res, $Val extends StoreConfig>
    implements $StoreConfigCopyWith<$Res> {
  _$StoreConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? apiBaseUrl = null,
    Object? storeName = null,
    Object? logoUrl = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? currency = null,
    Object? showBanners = null,
    Object? showReviews = null,
    Object? showRecommendations = null,
    Object? lowStockThreshold = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      apiBaseUrl: null == apiBaseUrl
          ? _value.apiBaseUrl
          : apiBaseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: null == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      showBanners: null == showBanners
          ? _value.showBanners
          : showBanners // ignore: cast_nullable_to_non_nullable
              as bool,
      showReviews: null == showReviews
          ? _value.showReviews
          : showReviews // ignore: cast_nullable_to_non_nullable
              as bool,
      showRecommendations: null == showRecommendations
          ? _value.showRecommendations
          : showRecommendations // ignore: cast_nullable_to_non_nullable
              as bool,
      lowStockThreshold: null == lowStockThreshold
          ? _value.lowStockThreshold
          : lowStockThreshold // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreConfigImplCopyWith<$Res>
    implements $StoreConfigCopyWith<$Res> {
  factory _$$StoreConfigImplCopyWith(
          _$StoreConfigImpl value, $Res Function(_$StoreConfigImpl) then) =
      __$$StoreConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String storeId,
      String apiBaseUrl,
      String storeName,
      String logoUrl,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      Color primaryColor,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      Color secondaryColor,
      String currency,
      bool showBanners,
      bool showReviews,
      bool showRecommendations,
      int lowStockThreshold});
}

/// @nodoc
class __$$StoreConfigImplCopyWithImpl<$Res>
    extends _$StoreConfigCopyWithImpl<$Res, _$StoreConfigImpl>
    implements _$$StoreConfigImplCopyWith<$Res> {
  __$$StoreConfigImplCopyWithImpl(
      _$StoreConfigImpl _value, $Res Function(_$StoreConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? apiBaseUrl = null,
    Object? storeName = null,
    Object? logoUrl = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? currency = null,
    Object? showBanners = null,
    Object? showReviews = null,
    Object? showRecommendations = null,
    Object? lowStockThreshold = null,
  }) {
    return _then(_$StoreConfigImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      apiBaseUrl: null == apiBaseUrl
          ? _value.apiBaseUrl
          : apiBaseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: null == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      showBanners: null == showBanners
          ? _value.showBanners
          : showBanners // ignore: cast_nullable_to_non_nullable
              as bool,
      showReviews: null == showReviews
          ? _value.showReviews
          : showReviews // ignore: cast_nullable_to_non_nullable
              as bool,
      showRecommendations: null == showRecommendations
          ? _value.showRecommendations
          : showRecommendations // ignore: cast_nullable_to_non_nullable
              as bool,
      lowStockThreshold: null == lowStockThreshold
          ? _value.lowStockThreshold
          : lowStockThreshold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreConfigImpl implements _StoreConfig {
  const _$StoreConfigImpl(
      {required this.storeId,
      required this.apiBaseUrl,
      required this.storeName,
      required this.logoUrl,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required this.primaryColor,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required this.secondaryColor,
      required this.currency,
      this.showBanners = true,
      this.showReviews = true,
      this.showRecommendations = true,
      this.lowStockThreshold = 10});

  factory _$StoreConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreConfigImplFromJson(json);

  @override
  final String storeId;
  @override
  final String apiBaseUrl;
  @override
  final String storeName;
  @override
  final String logoUrl;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color primaryColor;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color secondaryColor;
  @override
  final String currency;
  @override
  @JsonKey()
  final bool showBanners;
  @override
  @JsonKey()
  final bool showReviews;
  @override
  @JsonKey()
  final bool showRecommendations;
  @override
  @JsonKey()
  final int lowStockThreshold;

  @override
  String toString() {
    return 'StoreConfig(storeId: $storeId, apiBaseUrl: $apiBaseUrl, storeName: $storeName, logoUrl: $logoUrl, primaryColor: $primaryColor, secondaryColor: $secondaryColor, currency: $currency, showBanners: $showBanners, showReviews: $showReviews, showRecommendations: $showRecommendations, lowStockThreshold: $lowStockThreshold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreConfigImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.apiBaseUrl, apiBaseUrl) ||
                other.apiBaseUrl == apiBaseUrl) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor) &&
            (identical(other.secondaryColor, secondaryColor) ||
                other.secondaryColor == secondaryColor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.showBanners, showBanners) ||
                other.showBanners == showBanners) &&
            (identical(other.showReviews, showReviews) ||
                other.showReviews == showReviews) &&
            (identical(other.showRecommendations, showRecommendations) ||
                other.showRecommendations == showRecommendations) &&
            (identical(other.lowStockThreshold, lowStockThreshold) ||
                other.lowStockThreshold == lowStockThreshold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      apiBaseUrl,
      storeName,
      logoUrl,
      primaryColor,
      secondaryColor,
      currency,
      showBanners,
      showReviews,
      showRecommendations,
      lowStockThreshold);

  /// Create a copy of StoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreConfigImplCopyWith<_$StoreConfigImpl> get copyWith =>
      __$$StoreConfigImplCopyWithImpl<_$StoreConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreConfigImplToJson(
      this,
    );
  }
}

abstract class _StoreConfig implements StoreConfig {
  const factory _StoreConfig(
      {required final String storeId,
      required final String apiBaseUrl,
      required final String storeName,
      required final String logoUrl,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required final Color primaryColor,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required final Color secondaryColor,
      required final String currency,
      final bool showBanners,
      final bool showReviews,
      final bool showRecommendations,
      final int lowStockThreshold}) = _$StoreConfigImpl;

  factory _StoreConfig.fromJson(Map<String, dynamic> json) =
      _$StoreConfigImpl.fromJson;

  @override
  String get storeId;
  @override
  String get apiBaseUrl;
  @override
  String get storeName;
  @override
  String get logoUrl;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get primaryColor;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get secondaryColor;
  @override
  String get currency;
  @override
  bool get showBanners;
  @override
  bool get showReviews;
  @override
  bool get showRecommendations;
  @override
  int get lowStockThreshold;

  /// Create a copy of StoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreConfigImplCopyWith<_$StoreConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
