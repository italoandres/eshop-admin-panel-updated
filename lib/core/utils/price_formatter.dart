/// Extension para formatação de preços
extension PriceFormatting on num {
  /// Formata o número como preço brasileiro (R$ 0,00)
  String toFormattedPrice() {
    return 'R\$ ${toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
