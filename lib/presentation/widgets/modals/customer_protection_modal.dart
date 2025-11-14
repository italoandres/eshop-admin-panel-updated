import 'package:flutter/material.dart';

class CustomerProtectionModal extends StatelessWidget {
  const CustomerProtectionModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CustomerProtectionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield,
                  color: Color(0xFFD4AF37),
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Proteção do cliente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo scrollável
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentSecuritySection(context),
                  const SizedBox(height: 24),
                  _buildCouponSection(
                    Icons.card_giftcard,
                    'Cupom por perda ou dano',
                    'Ganhe um cupom de R\$ 25,00 para sua próxima compra se seu pacote for perdido ou danificado',
                  ),
                  const SizedBox(height: 16),
                  _buildCouponSection(
                    Icons.card_giftcard,
                    'Cupom por problema de estoque',
                    'Ganhe um cupom de R\$ 25,00 para sua próxima compra se o item que você pediu estiver esgotado',
                  ),
                  const SizedBox(height: 16),
                  _buildCouponSection(
                    Icons.card_giftcard,
                    'Cupom por atraso na coleta',
                    'Ganhe um cupom de R\$ 25,00 para sua próxima compra se o entregador não coletar seu pedido com o vendedor em até 7 dias após a confirmação do pedido',
                  ),
                  const SizedBox(height: 16),
                  _buildRefundSection(
                    Icons.lock,
                    'Reembolso automático por danos',
                    'Obtenha um reembolso total se seu pedido for perdido ou danificado. Você não precisa enviar uma solicitação de reembolso.',
                  ),
                  const SizedBox(height: 16),
                  _buildRefundSection(
                    Icons.access_time,
                    'Reembolso automático por atraso na coleta',
                    'Receba um reembolso total se o entregador não retirar seu pedido com o vendedor em até 7 dias úteis após a confirmação do pedido',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSecuritySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção
        const Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: Color(0xFFD4AF37),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Pagamento seguro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B4513),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Texto explicativo
        const Text(
          'Para garantir a segurança, as informações do seu cartão são criptografadas e protegidas contra acesso não autorizado.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'O TikTok Shop não vende, aluga ou cede suas informações pessoais a terceiros para fins de marketing.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 16),

        // Aceitamos pagamento de:
        const Text(
          'Aceitamos pagamento de:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 12),

        // Grid de logos de pagamento
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildPaymentMethodIcon(Icons.credit_card, 'Mastercard'),
            _buildPaymentMethodIcon(Icons.credit_card, 'Visa'),
            _buildPaymentMethodIcon(Icons.credit_card, 'Elo'),
            _buildPaymentMethodIcon(Icons.credit_card, 'Amex'),
            _buildPaymentMethodIcon(Icons.credit_card, 'Maestro'),
            _buildPaymentMethodIcon(Icons.receipt_long, 'Boleto'),
            _buildPaymentMethodIcon(Icons.pix, 'PIX'),
            _buildPaymentMethodIcon(Icons.payment, 'GPay'),
          ],
        ),

        const SizedBox(height: 16),

        // Certificações de segurança
        const Text(
          'Certificações de segurança:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            _buildCertificationBadge('MasterCard SecureCode'),
            const SizedBox(width: 12),
            _buildCertificationBadge('Verified by Visa'),
          ],
        ),

        const SizedBox(height: 16),

        // Link para política de privacidade
        GestureDetector(
          onTap: () {
            // TODO: Abrir política de privacidade
            debugPrint('Abrir política de privacidade');
          },
          child: const Text(
            'Para obter informações sobre como o TikTok Shop usa seus dados pessoais, consulte nossa Política de privacidade.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
              decoration: TextDecoration.underline,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodIcon(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCouponSection(IconData icon, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFD4AF37),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B4513),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRefundSection(IconData icon, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFD4AF37),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B4513),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
