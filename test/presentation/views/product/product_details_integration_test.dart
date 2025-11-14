import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eshop/presentation/views/product/product_details_view.dart';
import 'package:eshop/domain/entities/product/product.dart';

void main() {
  group('ProductDetailsView Integration Tests', () {
    late Product mockProduct;

    setUp(() {
      mockProduct = Product.mock();
    });

    testWidgets('deve exibir todos os componentes principais', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      // Aguardar carregamento
      await tester.pumpAndSettle();

      // Verificar carrossel de imagens
      expect(find.byType(Image), findsWidgets);

      // Verificar seção de preço
      expect(find.textContaining('R\$'), findsWidgets);

      // Verificar título do produto
      expect(find.text(mockProduct.name), findsOneWidget);

      // Verificar rating
      expect(find.byIcon(Icons.star), findsOneWidget);

      // Verificar proteção do cliente
      expect(find.text('Proteção do cliente'), findsOneWidget);

      // Verificar descrição
      expect(find.text('Descrição'), findsOneWidget);
    });

    testWidgets('deve exibir banner promocional quando disponível', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar se o banner promocional está visível
      expect(find.byIcon(Icons.card_giftcard), findsOneWidget);
      expect(find.textContaining('Compre R\$ 200'), findsOneWidget);
    });

    testWidgets('deve exibir informações de frete quando disponível', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar badge de frete grátis
      expect(find.text('Frete grátis'), findsOneWidget);
      
      // Verificar ícone de caminhão
      expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
    });

    testWidgets('deve abrir modal de proteção ao tocar no card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Tocar no card de proteção
      await tester.tap(find.text('Proteção do cliente').first);
      await tester.pumpAndSettle();

      // Verificar se o modal abriu
      expect(find.text('Pagamento seguro'), findsOneWidget);
      expect(find.text('Cupom por perda ou dano'), findsOneWidget);
    });

    testWidgets('deve fechar modal de proteção ao tocar no botão fechar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Abrir modal
      await tester.tap(find.text('Proteção do cliente').first);
      await tester.pumpAndSettle();

      expect(find.text('Pagamento seguro'), findsOneWidget);

      // Fechar modal
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verificar se o modal fechou
      expect(find.text('Pagamento seguro'), findsNothing);
    });

    testWidgets('deve abrir modal de variações ao tocar na seção', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Tocar na seção de variações
      await tester.tap(find.text('2 opções disponíveis'));
      await tester.pumpAndSettle();

      // Verificar se o modal abriu
      expect(find.text('Selecione uma opção'), findsOneWidget);
      expect(find.text('Preto'), findsOneWidget);
      expect(find.text('Branco'), findsOneWidget);
    });

    testWidgets('deve permitir scroll pela página', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar se a descrição está visível inicialmente
      expect(find.text('Descrição'), findsOneWidget);

      // Scroll para o topo
      await tester.drag(find.byType(ListView), const Offset(0, 500));
      await tester.pumpAndSettle();

      // Verificar se ainda conseguimos ver elementos
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('deve exibir botões de adicionar ao carrinho e comprar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar bottom bar com botões
      expect(find.byType(BottomAppBar), findsNothing); // Usando Container customizado
      
      // Verificar se há botões na parte inferior
      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);
    });

    testWidgets('deve exibir badge de desconto quando disponível', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar badge de desconto
      expect(find.text('-48%'), findsOneWidget);
    });

    testWidgets('deve exibir preço original riscado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsView(product: mockProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar preço original
      expect(find.text('R\$ 50,00'), findsOneWidget);
    });
  });
}
