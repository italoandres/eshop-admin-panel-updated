import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/banner_model.dart';

part 'banner_dto.freezed.dart';
part 'banner_dto.g.dart';

@freezed
class BannerDto with _$BannerDto {
  const BannerDto._();

  const factory BannerDto({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String imageUrl,
    required int order,
    required bool active,
    String? targetUrl,
    String? description,
  }) = _BannerDto;

  factory BannerDto.fromJson(Map<String, dynamic> json) =>
      _$BannerDtoFromJson(json);

  // Converter DTO para Model de domínio
  BannerModel toModel() {
    return BannerModel(
      id: id,
      title: title,
      imageUrl: imageUrl,
      order: order,
      active: active,
      targetUrl: targetUrl,
      description: description,
    );
  }
}
