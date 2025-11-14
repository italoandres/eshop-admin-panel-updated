import 'package:flutter/material.dart';
import 'package:eshop/domain/entities/product/promotion.dart';

class PromotionalBanner extends StatelessWidget {
  final Promotion promotion;
  final VoidCallback onTap;

  const PromotionalBanner({
    super.key,
    required this.promotion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Semantics(
        label: promotion.title,
        hint: 'Toque para ver detalhes da promoção',
        button: true,
        child: Material(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  // Ícone de presente
                  const Icon(
                    Icons.card_giftcard,
                    color: Color(0xFFFF4D67),
                    size: 20,
                  ),

                  const SizedBox(width: 12),

                  // Texto da promoção
                  Expanded(
                    child: Text(
                      promotion.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF4D67),
                      ),
                    ),
                  ),

                  // Seta
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFFF4D67),
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
