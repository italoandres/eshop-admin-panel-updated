// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BannerModelImpl _$$BannerModelImplFromJson(Map<String, dynamic> json) =>
    _$BannerModelImpl(
      id: json['_id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      active: json['active'] as bool? ?? true,
      targetUrl: json['targetUrl'] as String?,
      description: json['description'] as String?,
      storeId: json['storeId'] as String?,
      startAt: json['startAt'] == null
          ? null
          : DateTime.parse(json['startAt'] as String),
      endAt: json['endAt'] == null
          ? null
          : DateTime.parse(json['endAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BannerModelImplToJson(_$BannerModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'order': instance.order,
      'active': instance.active,
      'targetUrl': instance.targetUrl,
      'description': instance.description,
      'storeId': instance.storeId,
      'startAt': instance.startAt?.toIso8601String(),
      'endAt': instance.endAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
