import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgressiveDiscountBox extends StatelessWidget {
  final double currentTotal;
  final int currentDiscountPercent;
  final int nextDiscountPercent;
  final double nextDiscountThreshold;

  const ProgressiveDiscountBox({
    Key? key,
    required this.currentTotal,
    required this.currentDiscountPercent,
    required this.nextDiscountPercent,
    required this.nextDiscountThreshold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final amountToNext = nextDiscountThreshold - currentTotal;
    final progressPercent = (currentTotal / nextDiscountThreshold).clamp(0.0, 1.0);

    // Níveis de desconto
    final discountLevels = [
      {'percent': 25, 'threshold': 200.0},
      {'percent': 40, 'threshold': 400.0},
      {'percent': 65, 'threshold': 700.0},
      {'percent': 80, 'threshold': 1000.0},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E7D32).withOpacity(0.2),
            const Color(0xFF1B5E20).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e informação
          Row(
            children: [
              const Icon(
                Icons.local_offer,
                size: 20,
                color: Color(0xFF4CAF50),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFE0E0E0),
                      height: 1.3,
                    ),
                    children: currentDiscountPercent == 0
                        ? [
                            const TextSpan(text: 'Adicione '),
                            TextSpan(
                              text: currencyFormat.format(nextDiscountThreshold - currentTotal),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const TextSpan(text: ' para ganhar '),
                            TextSpan(
                              text: '25% OFF',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const TextSpan(text: '!'),
                          ]
                        : [
                            const TextSpan(text: 'Você desbloqueou '),
                            TextSpan(
                              text: '$currentDiscountPercent%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            if (amountToNext > 0) ...[
                              const TextSpan(text: '. Adicione mais '),
                              TextSpan(
                                text: currencyFormat.format(amountToNext),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const TextSpan(text: ' para alcançar '),
                              TextSpan(
                                text: '$nextDiscountPercent%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ] else ...[
                              const TextSpan(
                                text: ' de desconto!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Barra de progresso com steps
          Stack(
            children: [
              // Background da barra
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // Progresso atual
              FractionallySizedBox(
                widthFactor: progressPercent,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Steps com porcentagens
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: discountLevels.map((level) {
              final threshold = (level['threshold'] as num).toDouble();
              final percent = level['percent'] as int;
              final isCompleted = currentTotal >= threshold;
              final isCurrent = currentDiscountPercent == percent;

              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? const Color(0xFF4CAF50)
                          : isCurrent
                              ? const Color(0xFF66BB6A)
                              : Colors.grey[700],
                      border: Border.all(
                        color: isCompleted || isCurrent
                            ? const Color(0xFF4CAF50)
                            : Colors.grey[600]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : Text(
                              '$percent%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isCurrent ? Colors.white : Colors.grey[400],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isCompleted || isCurrent
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isCompleted || isCurrent
                          ? const Color(0xFF4CAF50)
                          : Colors.grey[500],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
