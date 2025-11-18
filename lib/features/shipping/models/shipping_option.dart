class ShippingOption {
  final String type;
  final String eta;
  final double price;
  final String? additionalInfo;

  ShippingOption({
    required this.type,
    required this.eta,
    required this.price,
    this.additionalInfo,
  });
}
