import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eshop/presentation/widgets/modals/customer_protection_modal.dart';

void main() {
  group('CustomerProtectionModal Widget Tests', () {
    testWidgets('deve exibir título "Proteção do cliente"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomerProtectionModal(),
          ),
        ),
      );

      expect(find.text('Proteção do cliente'), findsOneWidget);
    });

    testWidgets('deve exibir botão de fechar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomerProtectionModal(),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('deve exibir seção de pagamento seguro', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomerProtectionModal(),
          ),
        ),
      );

      expect(find.text('Pagamento seguro'), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('deve exibir métodos de pagamento', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomerProtectionModal(),
          ),
        ),
      );

      expect(find.text('Aceitamos pagamento de:'), findsOneWidget);
      expect(find.text('Mastercard'), findsOneWidget);
      expect(find.text('Visa'), findsOneWidget);
      expect(find.text('PIX'), findsOneWidget);
    });

    testWidgets('deve exibir seções de cupons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomerProtectionModal(),
          ),
        ),
      );

      expect(find.text('Cupom por perda ou dano'), findsOneWidget);
      expect(find.text('Cupom por problema de estoque'), findsOneWidget);
      expect(find.text('Cupom por atraso na coleta'), findsOneWidget);
    });

    testWidgets('deve exibir seções de reembolso', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomerProtectionModal(),
          ),
        ),
      );

      expect(find.text('Reembolso automático por danos'), findsOneWidget);
      expect(find.text('Reembolso automático por atraso na coleta'), findsOneWidget);
    });

    testWidgets('deve ser scrollável', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomerProtectionModal(),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('deve abrir modal com método show', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CustomerProtectionModal.show(context),
                child: const Text('Abrir Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir Modal'));
      await tester.pumpAndSettle();

      expect(find.byType(CustomerProtectionModal), findsOneWidget);
    });

    testWidgets('deve fechar modal ao tocar no botão fechar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CustomerProtectionModal.show(context),
                child: const Text('Abrir Modal'),
              ),
            ),
          ),
        ),
      );

      // Abrir modal
      await tester.tap(find.text('Abrir Modal'));
      await tester.pumpAndSettle();

      expect(find.byType(CustomerProtectionModal), findsOneWidget);

      // Fechar modal
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(CustomerProtectionModal), findsNothing);
    });

    testWidgets('deve exibir link para política de privacidade', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomerProtectionModal(),
          ),
        ),
      );

      expect(find.textContaining('Política de privacidade'), findsOneWidget);
    });
  });
}
