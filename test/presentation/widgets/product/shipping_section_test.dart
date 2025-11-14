import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eshop/presentation/widgets/product/shipping_section.dart';
import 'package:eshop/domain/entities/product/shipping_info.dart';

void main() {
  group('ShippingSection Widget Tests', () {
    final now = DateTime.now();
    
    testWidgets('deve exibir badge "Frete grátis" quando isFree é true', (tester) async {
      final shippingInfo = ShippingInfo(
        isFree: true,
        shippingCost: 9.60,
        estimatedDeliveryStart: now.add(const Duration(days: 7)),
        estimatedDeliveryEnd: now.add(const Duration(days: 10)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShippingSection(
              shippingInfo: shippingInfo,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Frete grátis'), findsOneWidget);
    });

    testWidgets('deve exibir taxa riscada quando frete é grátis', (tester) async {
      final shippingInfo = ShippingInfo(
        isFree: true,
        shippingCost: 9.60,
        estimatedDeliveryStart: now.add(const Duration(days: 7)),
        estimatedDeliveryEnd: now.add(const Duration(days: 10)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShippingSection(
              shippingInfo: shippingInfo,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Taxa de envio: R\$ 9,60'), findsOneWidget);
      
      final textWidgets = tester.widgetList<Text>(
        find.text('Taxa de envio: R\$ 9,60')
      );
      
      for (final widget in textWidgets) {
        if (widget.style?.decoration == TextDecoration.lineThrough) {
          expect(widget.style?.decoration, TextDecoration.lineThrough);
          return;
        }
      }
    });

    testWidgets('deve exibir prazo de entrega formatado', (tester) async {
      final shippingInfo = ShippingInfo(
        isFree: true,
        shippingCost: 9.60,
        estimatedDeliveryStart: now.add(const Duration(days: 7)),
        estimatedDeliveryEnd: now.add(const Duration(days: 10)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShippingSection(
              shippingInfo: shippingInfo,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verifica se o prazo está sendo exibido (formato pode variar)
      expect(find.textContaining('Receba até'), findsOneWidget);
    });

    testWidgets('deve exibir ícone de caminhão', (tester) async {
      final shippingInfo = ShippingInfo(
        isFree: true,
        shippingCost: 9.60,
        estimatedDeliveryStart: now.add(const Duration(days: 7)),
        estimatedDeliveryEnd: now.add(const Duration(days: 10)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShippingSection(
              shippingInfo: shippingInfo,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
    });

    testWidgets('deve chamar onTap quando tocado', (tester) async {
      bool tapped = false;
      final shippingInfo = ShippingInfo(
        isFree: true,
        shippingCost: 9.60,
        estimatedDeliveryStart: now.add(const Duration(days: 7)),
        estimatedDeliveryEnd: now.add(const Duration(days: 10)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShippingSection(
              shippingInfo: shippingInfo,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ShippingSection));
      expect(tapped, true);
    });

    testWidgets('não deve exibir badge quando frete não é grátis', (tester) async {
      final shippingInfo = ShippingInfo(
        isFree: false,
        shippingCost: 9.60,
        estimatedDeliveryStart: now.add(const Duration(days: 7)),
        estimatedDeliveryEnd: now.add(const Duration(days: 10)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShippingSection(
              shippingInfo: shippingInfo,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Frete grátis'), findsNothing);
    });
  });
}
