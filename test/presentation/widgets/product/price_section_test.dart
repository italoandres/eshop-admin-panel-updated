import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eshop/presentation/widgets/product/price_section.dart';
import 'package:eshop/domain/entities/product/installment_info.dart';

void main() {
  group('PriceSection Widget Tests', () {
    testWidgets('deve exibir preço atual corretamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceSection(
              currentPrice: 26.09,
            ),
          ),
        ),
      );

      expect(find.text('R\$ 26,09'), findsOneWidget);
    });

    testWidgets('deve exibir badge de desconto quando fornecido', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceSection(
              currentPrice: 26.09,
              discountPercentage: 48,
            ),
          ),
        ),
      );

      expect(find.text('-48%'), findsOneWidget);
    });

    testWidgets('não deve exibir badge de desconto quando não fornecido', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceSection(
              currentPrice: 26.09,
            ),
          ),
        ),
      );

      expect(find.text('-48%'), findsNothing);
    });

    testWidgets('deve exibir preço original riscado quando fornecido', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceSection(
              currentPrice: 26.09,
              originalPrice: 50.00,
            ),
          ),
        ),
      );

      expect(find.text('R\$ 50,00'), findsOneWidget);
      
      final textWidget = tester.widget<Text>(find.text('R\$ 50,00'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('deve exibir informações de parcelamento quando fornecido', (tester) async {
      const installment = InstallmentInfo(
        installments: 5,
        installmentValue: 5.22,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceSection(
              currentPrice: 26.09,
              installment: installment,
            ),
          ),
        ),
      );

      expect(find.text('5x R\$ 5,22'), findsOneWidget);
      expect(find.byIcon(Icons.credit_card), findsOneWidget);
    });

    testWidgets('não deve exibir parcelamento quando não fornecido', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceSection(
              currentPrice: 26.09,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.credit_card), findsNothing);
    });

    testWidgets('deve formatar valores monetários corretamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceSection(
              currentPrice: 1234.56,
              originalPrice: 2000.00,
            ),
          ),
        ),
      );

      expect(find.text('R\$ 1234,56'), findsOneWidget);
      expect(find.text('R\$ 2000,00'), findsOneWidget);
    });
  });
}
