import 'package:flutter/material.dart';

class PriceChangeAlert extends StatelessWidget {
  final String productName;
  final VoidCallback? onTap;

  const PriceChangeAlert({
    Key? key,
    required this.productName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 18,
            color: Colors.orange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'O preço de $productName mudou. Verifique o carrinho antes de continuar.',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFE0E0E0),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
