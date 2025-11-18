import 'package:flutter/material.dart';

class CustomerProtectionPage extends StatelessWidget {
  const CustomerProtectionPage({Key? key}) : super(key: key);

  static const goldenBrown = Color(0xFFA97400);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Header fixo
          _buildHeader(context),
          // Conteúdo scrollável
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Bloco: Pagamento seguro (especial com logos)
                  _buildPaymentSecurityBlock(),
                  const SizedBox(height: 24),
                  // Bloco: Cupom por perda ou dano
                  CustomerProtectionDetailBlock(
                    icon: Icons.confirmation_number_outlined,
                    title: 'Cupom por perda ou dano',
                    description:
                        'Ganhe um cupom de R\$ 25,00 para sua próxima compra se seu pacote for perdido ou danificado.',
                  ),
                  const SizedBox(height: 24),
                  // Bloco: Cupom por problema de estoque
                  CustomerProtectionDetailBlock(
                    icon: Icons.inventory_2_outlined,
                    title: 'Cupom por problema de estoque',
                    description:
                        'Ganhe um cupom de R\$ 15,00 se o vendedor não tiver o produto em estoque após a confirmação do pedido.',
                  ),
                  const SizedBox(height: 24),
                  // Bloco: Cupom por atraso na coleta
                  CustomerProtectionDetailBlock(
                    icon: Icons.schedule_outlined,
                    title: 'Cupom por atraso na coleta',
                    description:
                        'Ganhe um cupom de R\$ 10,00 se o vendedor atrasar a coleta do seu pedido em mais de 2 dias úteis.',
                  ),
                  const SizedBox(height: 24),
                  // Bloco: Reembolso automático por danos
                  CustomerProtectionDetailBlock(
                    icon: Icons.monetization_on_outlined,
                    title: 'Reembolso automático por danos',
                    description:
                        'Receba reembolso automático se o produto chegar danificado ou com defeito. Basta abrir uma reclamação com fotos em até 7 dias.',
                  ),
                  const SizedBox(height: 24),
                  // Bloco: Reembolso automático por atraso na coleta
                  CustomerProtectionDetailBlock(
                    icon: Icons.access_time_outlined,
                    title: 'Reembolso automático por atraso na coleta',
                    description:
                        'Receba reembolso completo se o vendedor não enviar o produto em até 5 dias úteis após a confirmação do pagamento.',
                  ),
                  const SizedBox(height: 24),
                  // Bloco: Seguro contra extravio
                  CustomerProtectionDetailBlock(
                    icon: Icons.shield_outlined,
                    title: 'Seguro contra extravio',
                    description:
                        'Proteção completa contra extravio durante o transporte. Caso o produto seja extraviado, você receberá reembolso total.',
                  ),
                  const SizedBox(height: 24),
                  // Bloco: Devolução gratuita
                  CustomerProtectionDetailBlock(
                    icon: Icons.autorenew,
                    title: 'Devolução gratuita',
                    description:
                        'Devolva produtos em até 7 dias sem custo adicional. O frete de devolução é por nossa conta em casos de defeito ou produto errado.',
                  ),
                  const SizedBox(height: 24),
                  // Bloco: Garantia estendida
                  CustomerProtectionDetailBlock(
                    icon: Icons.verified_user_outlined,
                    title: 'Garantia estendida',
                    description:
                        'Garantia adicional de 90 dias além da garantia do fabricante para produtos selecionados. Cobertura total contra defeitos.',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header com degradê e escudo
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFF8E1),
            Colors.white,
          ],
          stops: const [0.3, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              // Título
              const Expanded(
                child: Text(
                  'Proteção do cliente',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: goldenBrown,
                  ),
                ),
              ),
              // Escudo dourado
              const Icon(
                Icons.shield,
                color: goldenBrown,
                size: 32,
              ),
              const SizedBox(width: 12),
              // Botão X
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bloco especial: Pagamento seguro
  Widget _buildPaymentSecurityBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do bloco
          Row(
            children: const [
              Icon(
                Icons.credit_card,
                color: goldenBrown,
                size: 22,
              ),
              SizedBox(width: 12),
              Text(
                'Pagamento seguro',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: goldenBrown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Texto explicativo
          Text(
            'Para garantir a segurança das suas transações, todos os pagamentos são criptografados e processados por sistemas certificados internacionalmente.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'O TikTok Shop não vende produtos diretamente. Conectamos você com vendedores confiáveis e garantimos proteção total na compra.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Aceitamos pagamento de:
          Text(
            'Aceitamos pagamento de:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          // Logos de pagamento
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildPaymentLogo('Mastercard', Icons.credit_card),
              _buildPaymentLogo('Visa', Icons.credit_card),
              _buildPaymentLogo('Elo', Icons.credit_card),
              _buildPaymentLogo('Amex', Icons.credit_card),
              _buildPaymentLogo('Mercado Pago', Icons.account_balance_wallet),
              _buildPaymentLogo('Boleto', Icons.receipt_long),
              _buildPaymentLogo('Pix', Icons.qr_code_2),
              _buildPaymentLogo('Google Pay', Icons.smartphone),
            ],
          ),
          const SizedBox(height: 20),
          // Certificações
          Text(
            'Certificações de segurança:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildCertificationBadge('Mastercard SecureCode'),
              const SizedBox(width: 12),
              _buildCertificationBadge('Verified by Visa'),
            ],
          ),
        ],
      ),
    );
  }

  // Logo de pagamento
  Widget _buildPaymentLogo(String name, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: goldenBrown),
          const SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  // Badge de certificação
  Widget _buildCertificationBadge(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: goldenBrown.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: goldenBrown.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, size: 16, color: goldenBrown),
          const SizedBox(width: 6),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: goldenBrown,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget reutilizável para blocos de proteção
class CustomerProtectionDetailBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const CustomerProtectionDetailBlock({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  static const goldenBrown = Color(0xFFA97400);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do bloco
          Row(
            children: [
              Icon(
                icon,
                color: goldenBrown,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: goldenBrown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Descrição
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
