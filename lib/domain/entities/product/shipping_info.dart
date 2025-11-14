import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class ShippingInfo extends Equatable {
  final bool isFree;
  final num shippingCost;
  final DateTime estimatedDeliveryStart;
  final DateTime estimatedDeliveryEnd;

  const ShippingInfo({
    required this.isFree,
    required this.shippingCost,
    required this.estimatedDeliveryStart,
    required this.estimatedDeliveryEnd,
  });

  /// Retorna o prazo de entrega formatado: "Receba até 17-21 de nov"
  String get deliveryRange {
    final start = DateFormat('dd').format(estimatedDeliveryStart);
    final end = DateFormat('dd').format(estimatedDeliveryEnd);
    final month = DateFormat('MMM', 'pt_BR').format(estimatedDeliveryEnd);
    return 'Receba até $start-$end de $month';
  }

  @override
  List<Object?> get props => [
        isFree,
        shippingCost,
        estimatedDeliveryStart,
        estimatedDeliveryEnd,
      ];
}
