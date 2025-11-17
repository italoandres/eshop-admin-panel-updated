import 'package:flutter/material.dart';

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
                return _ProductCard(
                  title: 'Produto ${index + 1}',
                  price: 'R\$ ${(index + 1) * 10},00',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String price;

  const _ProductCard({
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Navegar para detalhes do produto
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Detalhes de $title'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // Informações do produto
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
