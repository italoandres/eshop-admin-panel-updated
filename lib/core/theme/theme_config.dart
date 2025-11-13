import 'package:flutter/material.dart';

class ThemeConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color errorColor;
  final Color warningColor;
  final Color backgroundColor;
  final String? fontFamily;
  
  const ThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.successColor = const Color(0xFF4CAF50),
    this.errorColor = const Color(0xFFF44336),
    this.warningColor = const Color(0xFFFF9800),
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.fontFamily,
  });
  
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: fontFamily ?? 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}

// Tema padrão (EShop)
const defaultTheme = ThemeConfig(
  primaryColor: Color(0xFF1976D2), // Azul
  secondaryColor: Color(0xFFFFC107), // Amarelo
  accentColor: Color(0xFF4CAF50), // Verde
);
