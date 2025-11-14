import 'package:flutter/material.dart';

class CustomerProtectionCard extends StatelessWidget {
  final VoidCallback onTap;

  const CustomerProtectionCard({
    super.key,
    required this.onTap,
  });

  Widget _buildBenefit(String text) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xFF00C853),
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8B4513),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Semantics(
        label: 'Proteção do cliente',
        hint: 'Toque para ver todas as proteções oferecidas',
        button: true,
        child: Material(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(
                        Icons.shield,
                        color: Color(0xFFD4AF37),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Proteção do cliente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF8B4513),
                        size: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Grid 2x2 de benefícios
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBenefit('Devolução gratuita'),
                            const SizedBox(height: 8),
                            _buildBenefit('Pagamento seguro'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBenefit('Reembolso automático por dano'),
                            const SizedBox(height: 8),
                            _buildBenefit('Cupom por atraso na coleta'),
                          ],
                        ),
                      ),
                    ],
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
