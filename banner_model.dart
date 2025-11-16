import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_model.freezed.dart';

@freezed
class BannerModel with _$BannerModel {
  const factory BannerModel({
    required String id,
    required String title,
    required String imageUrl,
    required int order,
    required bool active,
    String? targetUrl,
    String? description,
  }) = _BannerModel;
}
