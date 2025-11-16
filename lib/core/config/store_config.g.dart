// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreConfigImpl _$$StoreConfigImplFromJson(Map<String, dynamic> json) =>
    _$StoreConfigImpl(
      storeId: json['storeId'] as String,
      apiBaseUrl: json['apiBaseUrl'] as String,
      storeName: json['storeName'] as String,
      logoUrl: json['logoUrl'] as String,
      primaryColor: _colorFromJson(json['primaryColor'] as String),
      secondaryColor: _colorFromJson(json['secondaryColor'] as String),
      currency: json['currency'] as String,
      showBanners: json['showBanners'] as bool? ?? true,
      showReviews: json['showReviews'] as bool? ?? true,
      showRecommendations: json['showRecommendations'] as bool? ?? true,
    );

Map<String, dynamic> _$$StoreConfigImplToJson(_$StoreConfigImpl instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'apiBaseUrl': instance.apiBaseUrl,
      'storeName': instance.storeName,
      'logoUrl': instance.logoUrl,
      'primaryColor': _colorToJson(instance.primaryColor),
      'secondaryColor': _colorToJson(instance.secondaryColor),
      'currency': instance.currency,
      'showBanners': instance.showBanners,
      'showReviews': instance.showReviews,
      'showRecommendations': instance.showRecommendations,
    };
