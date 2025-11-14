import 'package:flutter/material.dart';

/// Tema customizado para a tela de detalhes do produto
class ProductDetailsTheme {
  // Cores
  static const Color discountBadge = Color(0xFFFF4D67);
  static const Color priceHighlight = Color(0xFFFF4D67);
  static const Color freeShippingBadge = Color(0xFF00C853);
  static const Color protectionBackground = Color(0xFFFFF8E1);
  static const Color protectionIcon = Color(0xFFD4AF37);
  static const Color protectionText = Color(0xFF8B4513);

  // Tipografia
  static const TextStyle priceMain = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: priceHighlight,
  );

  static const TextStyle priceOriginal = TextStyle(
    fontSize: 18,
    decoration: TextDecoration.lineThrough,
    color: Colors.grey,
  );

  static const TextStyle productTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: protectionText,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: Colors.black87,
    height: 1.5,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
