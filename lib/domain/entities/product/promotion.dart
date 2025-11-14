import 'package:equatable/equatable.dart';

class Promotion extends Equatable {
  final String id;
  final String title;
  final String description;
  final num minPurchase;
  final num discount;

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.minPurchase,
    required this.discount,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        minPurchase,
        discount,
      ];
}
