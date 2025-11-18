import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double discount;
  final int discountPercent;
  final VoidCallback onContinue;
  final bool isLoading;

  const CartSummary({
    Key? key,
    required this.subtotal,
    required this.discount,
    required this.discountPercent,
    required this.onContinue,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final total = subtotal - discount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Subtotal
              _buildSummaryRow(
                label: 'Subtotal',
                value: currencyFormat.format(subtotal),
                isSubtitle: true,
              ),

              // Desconto (se houver)
              if (discount > 0) ...[
                const SizedBox(height: 8),
                _buildSummaryRow(
                  label: 'Desconto progressivo ($discountPercent%)',
                  value: '- ${currencyFormat.format(discount)}',
                  isDiscount: true,
                ),
              ],

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 1),
              ),

              // Total
              _buildSummaryRow(
                label: 'Total',
                value: currencyFormat.format(total),
                isBold: true,
              ),

              const SizedBox(height: 16),

              // Botão Continuar
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'CONTINUAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isBold = false,
    bool isSubtitle = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSubtitle ? 14 : isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isSubtitle
                ? Colors.grey[700]
                : isDiscount
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF212121),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isDiscount
                ? const Color(0xFF2E7D32)
                : isBold
                    ? const Color(0xFF212121)
                    : Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
