import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Estado do componente
  int _currentPhotoIndex = 0;
  String _selectedColor = 'Azul';
  int _selectedColorIndex = 1;
  String _selectedSize = 'M';
  bool hasCouponBanner = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Conteúdo scrollável
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Espaço para o header fixo (aumentado para acomodar header + barra de progresso)
                SizedBox(height: MediaQuery.of(context).padding.top + 116),

                // Banner de cupom (opcional)
                if (hasCouponBanner) _buildCouponBanner(),

                // Carousel de fotos
                _buildPhotoCarousel(),

                // Avaliação
                _buildRating(),

                // Título + WhatsApp + Favorito
                _buildTitleSection(),

                // Preço
                _buildPriceSection(),

                const Divider(height: 32, thickness: 1),

                // Seletor de cor
                _buildColorSelector(),

                // Seletor de tamanho
                _buildSizeSelector(),

                // Alerta de estoque baixo
                _buildStockAlert(),

                const Divider(height: 32, thickness: 1),

                // Vendido por / Enviado por
                _buildSellerInfo(),

                const SizedBox(height: 100), // Espaço para o botão fixo
              ],
            ),
          ),

          // Header fixo no topo
          _buildFixedHeader(),

          // Botão adicionar ao carrinho fixo no rodapé
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildAddToCartButton(),
          ),
        ],
      ),
    );
  }

  // Header fixo (topo - fundo lilás com barra de progresso)
  Widget _buildFixedHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row com X e Carrinho
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 8,
                left: 8,
                right: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botão Fechar (X)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Botão Carrinho
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    onPressed: () {
                      // TODO: Navegar para carrinho
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navegando para o carrinho...')),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Barra de promoção progressiva
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  // Barra de promoção progressiva
  Widget _buildProgressBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Etapa 1
          _buildProgressStep(
            label: '25%',
            isActive: true,
            isCompleted: false,
          ),
          // Linha conectora
          Expanded(
            child: Container(
              height: 2,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // Etapa 2
          _buildProgressStep(
            label: '40%',
            isActive: false,
            isCompleted: false,
          ),
          // Linha conectora
          Expanded(
            child: Container(
              height: 2,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // Etapa 3
          _buildProgressStep(
            label: '65%',
            isActive: false,
            isCompleted: false,
          ),
          // Linha conectora
          Expanded(
            child: Container(
              height: 2,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // Prêmio final
          _buildProgressStep(
            label: 'R\$ 20',
            isActive: false,
            isCompleted: false,
            icon: Icons.card_giftcard,
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para etapas do progresso
  Widget _buildProgressStep({
    required String label,
    required bool isActive,
    required bool isCompleted,
    IconData? icon,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive
                ? Colors.white
                : Colors.white.withOpacity(0.3),
          ),
          child: icon != null
              ? Icon(
                  icon,
                  size: 16,
                  color: isCompleted || isActive
                      ? Theme.of(context).primaryColor
                      : Colors.white.withOpacity(0.7),
                )
              : Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isCompleted || isActive
                          ? Theme.of(context).primaryColor
                          : Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  // Banner de cupom
  Widget _buildCouponBanner() {
    return Container(
      height: 50,
      width: double.infinity,
      color: const Color(0xFFFFEB3B), // Amarelo
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            '+10% OFF',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9C27B0),
            ),
          ),
          const SizedBox(width: 8),
          const Flexible(
            child: Text(
              'na primeira compra! cupom',
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PRIMEIRA10',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Carousel de fotos do produto
  Widget _buildPhotoCarousel() {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: 4,
            onPageChanged: (index) {
              setState(() {
                _currentPhotoIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.image, size: 100, color: Colors.grey[400]),
                ),
              );
            },
          ),
          // Indicadores (bolinhas)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPhotoIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Avaliação
  Widget _buildRating() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            '4.66',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: List.generate(5, (index) {
              return const Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              );
            }),
          ),
          const SizedBox(width: 8),
          Text(
            'Baseado em 671 avaliações',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Título + WhatsApp + Favorito
  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Text(
              'Camisa Umbro TWR Striker Masculina',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Botão WhatsApp
          GestureDetector(
            onTap: () {
              // TODO: Abrir WhatsApp
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrindo WhatsApp...')),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF25D366),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.message,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Botão Favoritar
          GestureDetector(
            onTap: () {
              // TODO: Adicionar aos favoritos
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adicionado aos favoritos!')),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Preço
  Widget _buildPriceSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A partir de',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ 37,99',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'no Pix',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Seletor de cor
  Widget _buildColorSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cor: $_selectedColor',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6, // 6 cores disponíveis
              itemBuilder: (context, index) {
                final isSelected = index == _selectedColorIndex;
                final colors = ['Vermelho', 'Azul', 'Verde', 'Preto', 'Branco', 'Cinza'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                      _selectedColor = colors[index];
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300]!,
                        width: isSelected ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.image, color: Colors.grey[400]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Seletor de tamanho
  Widget _buildSizeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tamanho',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ['P', 'M', 'G', 'GG', 'EGG'].map((size) {
              final isSelected = size == _selectedSize;
              final isAvailable = size != 'EGG'; // EGG indisponível

              return GestureDetector(
                onTap: isAvailable
                    ? () {
                        setState(() {
                          _selectedSize = size;
                        });
                      }
                    : null,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : (isAvailable ? Colors.grey[300]! : Colors.grey[200]!),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isAvailable ? Colors.white : Colors.grey[100],
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isAvailable
                            ? (isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black)
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Alerta de estoque baixo
  Widget _buildStockAlert() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0), // Laranja claro
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF57C00),
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Só 7 unidades em estoque!',
            style: TextStyle(
              color: Color(0xFFF57C00),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Vendido por / Enviado por
  Widget _buildSellerInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Vendido por ',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const Text(
                'Netshoes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Enviado por ',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const Text(
                'FULL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9C27B0), // Roxo
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.local_shipping,
                color: Color(0xFF9C27B0),
                size: 20,
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.info_outline,
                color: Colors.grey[600],
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Botão adicionar ao carrinho
  Widget _buildAddToCartButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Adicionar ao carrinho
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto adicionado ao carrinho!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Adicionar ao Carrinho',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
