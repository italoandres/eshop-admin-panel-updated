import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eshop/presentation/widgets/product/customer_protection_card.dart';

void main() {
  group('CustomerProtectionCard Widget Tests', () {
    testWidgets('deve exibir título "Proteção do cliente"', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerProtectionCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Proteção do cliente'), findsOneWidget);
    });

    testWidgets('deve exibir ícone de escudo', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerProtectionCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.shield), findsOneWidget);
    });

    testWidgets('deve exibir 4 benefícios', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerProtectionCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Devolução gratuita'), findsOneWidget);
      expect(find.text('Pagamento seguro'), findsOneWidget);
      expect(find.text('Reembolso automático por dano'), findsOneWidget);
      expect(find.text('Cupom por atraso na coleta'), findsOneWidget);
    });

    testWidgets('deve exibir ícones de check em cada benefício', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerProtectionCard(
              onTap: () {},
            ),
          ),
        ),
      );

      // Deve ter 4 ícones de check (um para cada benefício)
      expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
    });

    testWidgets('deve exibir seta à direita', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerProtectionCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('deve chamar onTap quando tocado', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerProtectionCard(
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomerProtectionCard));
      expect(tapped, true);
    });

    testWidgets('deve ter fundo bege/creme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerProtectionCard(
              onTap: () {},
            ),
          ),
        ),
      );

      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(CustomerProtectionCard),
          matching: find.byType(Material),
        ).first,
      );

      expect(material.color, const Color(0xFFFFF8E1));
    });
  });
}
