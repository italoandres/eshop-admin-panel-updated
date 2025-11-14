import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';
import '../../../domain/entities/product/progressive_discount_rule.dart';

class DiscountBannerCard extends StatelessWidget {
  final ProgressiveDiscountRule discountRule;
  final num productPrice;
  final VoidCallback onTap;

  const DiscountBannerCard({
    super.key,
    required this.discountRule,
    required this.productPrice,
    required this.onTap,
  });

  String _buildDiscountMessage() {
    if (discountRule.tiers.length < 2) return '';
    
    // Pega o desconto de 2 produtos (segundo nível)
    final secondTier = discountRule.tiers[1];
    final discountPercent = secondTier.discountPercent;
    
    return 'Escolha outro produto e ganhe ${discountPercent.toStringAsFixed(0)}% de desconto';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
        decoration: BoxDecoration(
          color: AppColors.discountBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.discountBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.card_giftcard,
              color: AppColors.discountText,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _buildDiscountMessage(),
                style: const TextStyle(
                  color: AppColors.discountText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.discountText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
