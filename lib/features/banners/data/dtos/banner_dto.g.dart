// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BannerDtoImpl _$$BannerDtoImplFromJson(Map<String, dynamic> json) =>
    _$BannerDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      order: (json['order'] as num).toInt(),
      active: json['active'] as bool,
      targetUrl: json['targetUrl'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$BannerDtoImplToJson(_$BannerDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'order': instance.order,
      'active': instance.active,
      'targetUrl': instance.targetUrl,
      'description': instance.description,
    };
