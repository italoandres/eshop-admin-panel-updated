import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/entities/product/price_tag.dart';

class ProductVariantsModal extends StatelessWidget {
  final List<PriceTag> variants;
  final PriceTag selectedVariant;
  final Function(PriceTag) onVariantSelected;

  const ProductVariantsModal({
    super.key,
    required this.variants,
    required this.selectedVariant,
    required this.onVariantSelected,
  });

  static Future<PriceTag?> show({
    required BuildContext context,
    required List<PriceTag> variants,
    required PriceTag selectedVariant,
  }) {
    return showModalBottomSheet<PriceTag>(
      context: context,
      builder: (context) => ProductVariantsModal(
        variants: variants,
        selectedVariant: selectedVariant,
        onVariantSelected: (variant) {
          Navigator.pop(context, variant);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione uma opção',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: variants.map((priceTag) {
              final isSelected = selectedVariant.id == priceTag.id;
              return GestureDetector(
                onTap: () => onVariantSelected(priceTag),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: isSelected ? 2.0 : 1.0,
                      color: isSelected ? AppColors.primary : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        priceTag.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        priceTag.price.toFormattedPrice(),
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
