class InstallmentInfo {
  final int installments;
  final num installmentValue;

  const InstallmentInfo({
    required this.installments,
    required this.installmentValue,
  });

  /// Retorna o texto formatado: "5x R$ 5,59"
  String get displayText =>
      '${installments}x R\$ ${installmentValue.toStringAsFixed(2).replaceAll('.', ',')}';
}
