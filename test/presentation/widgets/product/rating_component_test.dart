import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eshop/presentation/widgets/product/rating_component.dart';

void main() {
  group('RatingComponent Widget Tests', () {
    testWidgets('deve exibir estrela e nota corretamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingComponent(
              rating: 4.3,
              reviewCount: 336,
              soldCount: 1740,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('4.3'), findsOneWidget);
    });

    testWidgets('deve formatar número de reviews corretamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingComponent(
              rating: 4.5,
              reviewCount: 336,
              soldCount: 1000,
            ),
          ),
        ),
      );

      expect(find.text('(336)'), findsOneWidget);
    });

    testWidgets('deve formatar número de reviews grandes com k', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingComponent(
              rating: 4.5,
              reviewCount: 1500,
              soldCount: 1000,
            ),
          ),
        ),
      );

      expect(find.text('(1.5k)'), findsOneWidget);
    });

    testWidgets('deve exibir número de vendidos corretamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingComponent(
              rating: 4.3,
              reviewCount: 336,
              soldCount: 1740,
            ),
          ),
        ),
      );

      expect(find.text('1.7k vendidos'), findsOneWidget);
    });

    testWidgets('deve exibir separador entre reviews e vendidos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingComponent(
              rating: 4.3,
              reviewCount: 336,
              soldCount: 1740,
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      final separators = containers.where((c) => 
        c.constraints?.maxWidth == 1 && c.constraints?.maxHeight == 12
      );
      
      expect(separators.isNotEmpty, true);
    });

    testWidgets('deve formatar nota com 1 casa decimal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingComponent(
              rating: 4.567,
              reviewCount: 100,
              soldCount: 500,
            ),
          ),
        ),
      );

      expect(find.text('4.6'), findsOneWidget);
      expect(find.text('4.567'), findsNothing);
    });
  });
}
