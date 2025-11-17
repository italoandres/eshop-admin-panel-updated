import 'package:flutter/material.dart';

class ProductProgressiveDiscountBanner extends StatelessWidget {
  final double discountPercent;

  const ProductProgressiveDiscountBanner({
    Key? key,
    required this.discountPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () {
          // TODO: Abrir página explicando o desconto progressivo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Navegando para detalhes do desconto progressivo...'),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4E8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // Ícone de ticket à esquerda
              const Icon(
                Icons.confirmation_number,
                color: Color(0xFFD81B60),
                size: 22,
              ),
              const SizedBox(width: 12),
              // Texto
              Expanded(
                child: Text(
                  'Adicione ao carrinho e ganhe ${discountPercent.toStringAsFixed(0)}% de desconto',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD81B60),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Seta à direita
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFD81B60),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
