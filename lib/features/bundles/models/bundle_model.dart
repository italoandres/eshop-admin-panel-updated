class BundleProduct {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  BundleProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}

class ProductBundle {
  final BundleProduct mainProduct;
  final BundleProduct complementaryProduct;
  final double bundleDiscountPercent;
  final double totalPrice;
  final double discountedPrice;

  ProductBundle({
    required this.mainProduct,
    required this.complementaryProduct,
    required this.bundleDiscountPercent,
    required this.totalPrice,
    required this.discountedPrice,
  });

  double get savedAmount => totalPrice - discountedPrice;
}
