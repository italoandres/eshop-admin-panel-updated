import 'package:equatable/equatable.dart';

class Banner extends Equatable {
  final String id;
  final String storeId;
  final String title;
  final String imageUrl;
  final String targetUrl;
  final int order;
  final bool active;
  final DateTime? startAt;
  final DateTime? endAt;

  const Banner({
    required this.id,
    required this.storeId,
    required this.title,
    required this.imageUrl,
    required this.targetUrl,
    required this.order,
    required this.active,
    this.startAt,
    this.endAt,
  });

  @override
  List<Object?> get props => [
        id,
        storeId,
        title,
        imageUrl,
        targetUrl,
        order,
        active,
        startAt,
        endAt,
      ];
}
