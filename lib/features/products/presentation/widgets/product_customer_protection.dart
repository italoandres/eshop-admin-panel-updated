import 'package:flutter/material.dart';
import '../pages/customer_protection_page.dart';

class ProductCustomerProtectionSection extends StatelessWidget {
  const ProductCustomerProtectionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const goldenBrown = Color(0xFFA97400);
    const lightYellow = Color(0xFFFFF8E1);
    const checkGreen = Color(0xFF4CAF50);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const CustomerProtectionPage(),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: lightYellow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: goldenBrown,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Proteção do cliente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: goldenBrown,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: goldenBrown,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Lista de benefícios em 2 colunas
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coluna 1
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBenefitItem(
                          icon: checkGreen,
                          text: 'Devolução gratuita',
                        ),
                        const SizedBox(height: 10),
                        _buildBenefitItem(
                          icon: checkGreen,
                          text: 'Pagamento seguro',
                        ),
                        const SizedBox(height: 10),
                        _buildBenefitItem(
                          icon: checkGreen,
                          text: 'Reembolso automático por dano',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Coluna 2
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBenefitItem(
                          icon: checkGreen,
                          text: 'Seguro contra extravio',
                        ),
                        const SizedBox(height: 10),
                        _buildBenefitItem(
                          icon: checkGreen,
                          text: 'Cupom por atraso na coleta',
                        ),
                        const SizedBox(height: 10),
                        _buildBenefitItem(
                          icon: checkGreen,
                          text: 'Garantia estendida',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({required Color icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          color: icon,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
