import 'package:flutter/material.dart';
import 'package:eshop/core/constant/app_colors.dart';
import 'package:eshop/core/utils/price_formatter.dart';
import 'package:eshop/domain/entities/product/installment_info.dart';

class PriceSection extends StatelessWidget {
  final num currentPrice;
  final num? originalPrice;
  final int? discountPercentage;
  final InstallmentInfo? installment;

  const PriceSection({
    super.key,
    required this.currentPrice,
    this.originalPrice,
    this.discountPercentage,
    this.installment,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha principal: Badge de desconto + Preços
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Badge de desconto
                if (discountPercentage != null && discountPercentage! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.discountBadge,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-$discountPercentage%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (discountPercentage != null && discountPercentage! > 0)
                  const SizedBox(width: 8),

                // Preço atual
                Semantics(
                  label: 'Preço: ${currentPrice.toFormattedPrice()}',
                  child: Text(
                    currentPrice.toFormattedPrice(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Preço original riscado
                if (originalPrice != null && originalPrice! > currentPrice)
                  Text(
                    originalPrice!.toFormattedPrice(),
                    style: const TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),

            // Linha de parcelamento
            if (installment != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.credit_card,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    installment!.displayText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
