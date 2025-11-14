import 'package:flutter/material.dart';
import 'package:eshop/domain/entities/product/shipping_info.dart';

class ShippingSection extends StatelessWidget {
  final ShippingInfo shippingInfo;
  final VoidCallback onTap;

  const ShippingSection({
    super.key,
    required this.shippingInfo,
    required this.onTap,
  });

  String _formatPrice(num price) {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Semantics(
        label: shippingInfo.isFree
            ? 'Frete grátis, ${shippingInfo.deliveryRange}'
            : 'Frete ${_formatPrice(shippingInfo.shippingCost)}, ${shippingInfo.deliveryRange}',
        hint: 'Toque para ver opções de envio',
        button: true,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 0,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Ícone de caminhão
                  const Icon(
                    Icons.local_shipping_outlined,
                    color: Colors.grey,
                    size: 24,
                  ),

                  const SizedBox(width: 12),

                  // Conteúdo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge "Frete grátis" ou prazo
                        Row(
                          children: [
                            if (shippingInfo.isFree)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C853),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Frete grátis',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            if (shippingInfo.isFree) const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                shippingInfo.deliveryRange,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Taxa de envio
                        if (!shippingInfo.isFree || shippingInfo.shippingCost > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Taxa de envio: ${_formatPrice(shippingInfo.shippingCost)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                decoration: shippingInfo.isFree
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Seta
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
