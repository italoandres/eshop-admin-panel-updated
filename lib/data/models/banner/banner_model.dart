import 'dart:convert';

import '../../../domain/entities/banner/banner.dart';

class BannerModel extends Banner {
  const BannerModel({
    required super.id,
    required super.storeId,
    required super.title,
    required super.imageUrl,
    required super.targetUrl,
    required super.order,
    required super.active,
    super.startAt,
    super.endAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] ?? json['id'] ?? '',
      storeId: json['storeId'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      targetUrl: json['targetUrl'] ?? '',
      order: json['order'] ?? 0,
      active: json['active'] ?? true,
      startAt: json['startAt'] != null ? DateTime.parse(json['startAt']) : null,
      endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'title': title,
      'imageUrl': imageUrl,
      'targetUrl': targetUrl,
      'order': order,
      'active': active,
      'startAt': startAt?.toIso8601String(),
      'endAt': endAt?.toIso8601String(),
    };
  }

  factory BannerModel.fromEntity(Banner banner) {
    return BannerModel(
      id: banner.id,
      storeId: banner.storeId,
      title: banner.title,
      imageUrl: banner.imageUrl,
      targetUrl: banner.targetUrl,
      order: banner.order,
      active: banner.active,
      startAt: banner.startAt,
      endAt: banner.endAt,
    );
  }
}

List<BannerModel> bannerModelListFromJson(String str) {
  final jsonData = json.decode(str);
  return List<BannerModel>.from(
    jsonData.map((x) => BannerModel.fromJson(x)),
  );
}

String bannerModelListToJson(List<BannerModel> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}
