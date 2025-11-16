import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_config.freezed.dart';
part 'store_config.g.dart';

@freezed
class StoreConfig with _$StoreConfig {
  const factory StoreConfig({
    required String storeId,
    required String apiBaseUrl,
    required String storeName,
    required String logoUrl,
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
    required Color primaryColor,
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
    required Color secondaryColor,
    required String currency,
    @Default(true) bool showBanners,
    @Default(true) bool showReviews,
    @Default(true) bool showRecommendations,
  }) = _StoreConfig;

  factory StoreConfig.fromJson(Map<String, dynamic> json) =>
      _$StoreConfigFromJson(json);

  // Configuração padrão para desenvolvimento
  static StoreConfig get defaultConfig => const StoreConfig(
        storeId: 'default-store',
        apiBaseUrl: 'https://api.example.com',
        storeName: 'Minha Loja',
        logoUrl: 'https://via.placeholder.com/150',
        primaryColor: Color(0xFF6200EE),
        secondaryColor: Color(0xFF03DAC6),
        currency: 'R\$',
      );
}

// Conversores de cor para JSON
Color _colorFromJson(String color) {
  return Color(int.parse(color.replaceFirst('#', '0xFF')));
}

String _colorToJson(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}
