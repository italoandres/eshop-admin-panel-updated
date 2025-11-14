import 'package:flutter/material.dart';
import 'package:eshop/domain/entities/product/progressive_discount_rule.dart';

class ProgressiveDiscountBanner extends StatelessWidget {
  final ProgressiveDiscountRule rule;
  final int currentQuantity;
  final num originalPrice;
  final VoidCallback onTap;

  const ProgressiveDiscountBanner({
    super.key,
    required this.rule,
    required this.currentQuantity,
    required this.originalPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentTier = rule.getApplicableTier(currentQuantity);
    final nextTier = rule.getNextTier(currentQuantity);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: _getGradient(currentTier, nextTier),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildIcon(currentTier, nextTier),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContent(currentTier, nextTier),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(DiscountTier? current, DiscountTier? next) {
    if (next == null) {
      return const Icon(Icons.emoji_events, color: Colors.white, size: 32);
    }
    return const Icon(Icons.card_giftcard, color: Colors.white, size: 32);
  }

  Widget _buildContent(DiscountTier? current, DiscountTier? next) {
    if (current == null) {
      // Nenhum desconto ainda
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Desconto Progressivo Disponível!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Adicione ${next!.quantity} e ganhe ${next.discountPercent.toStringAsFixed(0)}% OFF',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      );
    }

    if (next == null) {
      // Desconto máximo atingido
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎉 Desconto Máximo Atingido!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${current.discountPercent.toStringAsFixed(0)}% OFF aplicado',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      );
    }

    // Tem desconto atual e próximo disponível
    final quantityNeeded = next.quantity - currentQuantity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${current.discountPercent.toStringAsFixed(0)}% OFF Ativo',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Adicione +$quantityNeeded e ganhe ${next.discountPercent.toStringAsFixed(0)}% OFF!',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  LinearGradient _getGradient(DiscountTier? current, DiscountTier? next) {
    if (next == null) {
      // Máximo atingido - dourado
      return const LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      );
    }

    if (current == null) {
      // Nenhum desconto - verde
      return const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF45a049)],
      );
    }

    // Desconto intermediário - azul
    return const LinearGradient(
      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    );
  }
}
