import 'package:flutter/material.dart';
import 'package:eshop/domain/entities/product/price_tag.dart';

class ProductVariantsSection extends StatelessWidget {
  final List<PriceTag> variants;
  final VoidCallback onTap;

  const ProductVariantsSection({
    super.key,
    required this.variants,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayVariants = variants.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                // Ícone de grid
                const Icon(
                  Icons.grid_view_rounded,
                  color: Colors.grey,
                  size: 24,
                ),

                const SizedBox(width: 12),

                // Miniaturas das variações
                ...displayVariants.map((variant) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        variant.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    )),

                // Texto "X opções disponíveis"
                Expanded(
                  child: Text(
                    '${variants.length} opções disponíveis',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
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
    );
  }
}
