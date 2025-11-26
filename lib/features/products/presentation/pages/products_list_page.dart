import 'package:flutter/material.dart';
import '../../../../core/widgets/product_card.dart';

class ProductsListPage extends StatelessWidget {
  final String categoryName;

  const ProductsListPage({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar busca
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // TODO: Navegar para carrinho
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros e Ordenação
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Botão Filtros
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Abrir bottom sheet de filtros
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Filtros em breve!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filtros'),
                ),
                const SizedBox(width: 12),
                // Botão Ordenar
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Abrir bottom sheet de ordenação
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ordenação em breve!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.sort),
                  label: const Text('Ordenar'),
                ),
              ],
            ),
          ),

          // GridView de produtos
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                // TODO: Substituir por dados reais da API
                final fakeProduct = {
                  '_id': 'prod-${index + 1}',
                  'name': 'Produto ${index + 1}',
                  'priceTags': [
                    {'name': 'Preço', 'price': (index + 1) * 10.0}
                  ],
                  'images': [],
                };
                return ProductCard(
                  product: fakeProduct,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
