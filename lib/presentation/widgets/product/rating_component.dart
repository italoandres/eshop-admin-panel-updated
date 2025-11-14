import 'package:flutter/material.dart';

class RatingComponent extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final int soldCount;

  const RatingComponent({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
  });

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Semantics(
        label: 'Avaliação: $rating estrelas, $reviewCount avaliações, $soldCount vendidos',
        child: Row(
          children: [
            // Estrela
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 18,
            ),
            const SizedBox(width: 4),

            // Nota
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(width: 4),

            // Número de reviews
            Text(
              '(${_formatNumber(reviewCount)})',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 8),

            // Separador
            Container(
              width: 1,
              height: 12,
              color: Colors.grey.shade300,
            ),

            const SizedBox(width: 8),

            // Vendidos
            Text(
              '${_formatNumber(soldCount)} vendidos',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
