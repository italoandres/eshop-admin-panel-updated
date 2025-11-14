/// Configuração customizável para proteção do cliente (White Label)
class CustomerProtectionConfig {
  final bool showProtectionCard;
  final num couponValue;
  final List<String> paymentMethods;
  final String privacyPolicyUrl;

  const CustomerProtectionConfig({
    this.showProtectionCard = true,
    this.couponValue = 25.00,
    this.paymentMethods = const [
      'mastercard',
      'visa',
      'elo',
      'amex',
      'maestro',
      'boleto',
      'pix',
      'gpay',
    ],
    required this.privacyPolicyUrl,
  });

  /// Configuração padrão
  static const CustomerProtectionConfig defaultConfig = CustomerProtectionConfig(
    privacyPolicyUrl: 'https://eshop.com/privacidade',
  );

  /// Exemplo de configuração customizada para um cliente
  static CustomerProtectionConfig forClient(String clientId) {
    // Aqui você pode carregar configurações específicas do cliente
    // Por exemplo, de um banco de dados ou arquivo de configuração
    return CustomerProtectionConfig(
      showProtectionCard: true,
      couponValue: 30.00, // Cliente pode ter valor diferente
      privacyPolicyUrl: 'https://$clientId.com/privacidade',
    );
  }
}
