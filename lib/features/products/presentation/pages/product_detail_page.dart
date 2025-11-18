import 'package:flutter/material.dart';
import '../widgets/product_customer_protection.dart';
import '../widgets/product_progressive_discount_banner.dart';

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
  bool _isDescriptionExpanded = false;

  // Dados mock
  final mockRating = 4.66;
  final mockRatingCount = 671;
  final mockRecommendationPercent = 0.95;
  final mockReviews = const [
    {'user': 'Edson', 'date': '17 de nov de 2025', 'comment': 'Ótimo produto. Recomendo!', 'rating': 5},
    {'user': 'Kelly', 'date': '12 de nov de 2025', 'comment': 'Top demais!', 'rating': 5},
    {'user': 'Carlos', 'date': '10 de nov de 2025', 'comment': 'Superou minhas expectativas!', 'rating': 5},
    {'user': 'Ana', 'date': '8 de nov de 2025', 'comment': 'Produto de qualidade. Vale a pena.', 'rating': 4},
  ];

  // Dados de preço e desconto
  final double mockOriginalPrice = 50.00;
  final double? mockProgressiveDiscountPercent = 48.0; // 48% de desconto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // Conteúdo scrollável
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Espaço para o header fixo (barra lilás 40px + barra progressiva 40px = 80px)
                SizedBox(height: MediaQuery.of(context).padding.top + 80),

                // Banner de cupom (opcional) - scrollável
                if (hasCouponBanner) _buildCouponBanner(),

                // Carousel de fotos
                _buildPhotoCarousel(),

                // Avaliação
                _buildRating(),

                // Título + WhatsApp + Favorito
                _buildTitleSection(),

                // Preço
                _buildPriceSection(),

                // Tarja de desconto progressivo (se houver)
                if (mockProgressiveDiscountPercent != null && mockProgressiveDiscountPercent! > 0)
                  ProductProgressiveDiscountBanner(
                    discountPercent: mockProgressiveDiscountPercent!,
                  ),

                Divider(height: 32, thickness: 1, color: Colors.grey[800]),

                // Seletor de cor
                _buildColorSelector(),

                // Seletor de tamanho
                _buildSizeSelector(),

                // Alerta de estoque baixo
                _buildStockAlert(),

                const SizedBox(height: 24),

                // Seção: Prazo de entrega
                _buildDeliverySection(),

                Divider(height: 32, thickness: 1, color: Colors.grey[800]),

                // Seção: Proteção do Cliente
                const ProductCustomerProtectionSection(),

                Divider(height: 32, thickness: 1, color: Colors.grey[800]),

                // Seção: Descrição do Produto (accordion)
                _buildDescriptionSection(),

                Divider(height: 32, thickness: 1, color: Colors.grey[800]),

                // Seção: Avaliação do produto
                _buildRatingOverview(),

                const SizedBox(height: 16),

                // Seção: Recomendações
                _buildRecommendationSection(),

                const SizedBox(height: 16),

                // Botão: Mostrar todas avaliações
                _buildShowAllReviewsButton(),

                const SizedBox(height: 24),

                // Seção: Comentários mais recentes
                _buildRecentReviews(),

                const SizedBox(height: 120), // Espaço para o botão fixo
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

  // Header fixo (topo - barra lilás 40px + barra de desconto progressivo)
  Widget _buildFixedHeader() {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container LILÁS - 40px de altura
          Container(
            height: statusBarHeight + 40,
            color: const Color(0xFF6200EE),
            child: Column(
              children: [
                SizedBox(height: statusBarHeight),
                // Área lilás com botões (40px visíveis)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                ),
              ],
            ),
          ),
          // Barra de desconto progressivo PRETA - colada abaixo da barra lilás (fixa)
          _buildProgressBar(),
        ],
      ),
    );
  }

  // Barra de promoção progressiva
  Widget _buildProgressBar() {
    return Container(
      height: 40,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              color: Colors.white,
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
              color: Colors.grey[400],
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
                color: Colors.white,
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
                color: Colors.grey[850],
                border: Border.all(color: Colors.grey[700]!),
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
    // Cálculo do preço com desconto
    final discountPercent = mockProgressiveDiscountPercent ?? 0;
    final discountedPrice = mockOriginalPrice * (1 - (discountPercent / 100));
    final installmentPrice = discountedPrice / 3;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha com badge de desconto e preço original riscado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge de desconto (se houver)
              if (mockProgressiveDiscountPercent != null && mockProgressiveDiscountPercent! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-${mockProgressiveDiscountPercent!.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // Preço original riscado
              if (mockProgressiveDiscountPercent != null && mockProgressiveDiscountPercent! > 0)
                Text(
                  'R\$ ${mockOriginalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey[500],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Preço final com desconto
          Text(
            'A partir de',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'no Pix',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Parcelamento (calculado com base no preço com desconto)
          Text(
            'ou 3x de R\$ ${installmentPrice.toStringAsFixed(2)} sem juros',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
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
              color: Colors.white,
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
                            : Colors.grey[700]!,
                        width: isSelected ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.image, color: Colors.grey[600]),
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
              color: Colors.white,
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
                          : (isAvailable ? Colors.grey[700]! : Colors.grey[800]!),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isAvailable ? Colors.grey[850] : Colors.grey[900],
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
                                : Colors.white)
                            : Colors.grey[600],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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

  // Botão adicionar ao carrinho
  Widget _buildAddToCartButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
          backgroundColor: const Color(0xFF4CAF50),
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

  // (A) Seção: Prazo de entrega
  Widget _buildDeliverySection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prazo de entrega',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Chega dia 25 de novembro para o CEP 01310-100, se você finalizar o pedido com a opção de entrega Normal.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Alterar CEP
                },
                child: Text(
                  'Alterar CEP',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6200EE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Ver outras formas de entrega
                },
                child: Text(
                  'Ver outras formas de entrega',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6200EE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // (B) Seção: Descrição do Produto (accordion)
  Widget _buildDescriptionSection() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isDescriptionExpanded = !_isDescriptionExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Descrição do Produto',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  _isDescriptionExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (_isDescriptionExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'Camisa Umbro TWR Striker masculina confeccionada em material de alta qualidade e tecnologia. '
              'Perfeita para a prática esportiva, oferece conforto e estilo. '
              'Detalhes modernos e acabamento impecável. '
              'Ideal para quem busca performance e design.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
                height: 1.6,
              ),
            ),
          ),
      ],
    );
  }

  // (C) Seção: Avaliação do produto
  Widget _buildRatingOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Avaliação do produto',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Avaliações dos clientes',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                mockRating.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < mockRating.floor()
                            ? Icons.star
                            : (index < mockRating ? Icons.star_half : Icons.star_border),
                        color: Colors.amber,
                        size: 24,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Baseado em $mockRatingCount avaliações.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // (D) Seção: Recomendações
  Widget _buildRecommendationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${(mockRecommendationPercent * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              tween: Tween<double>(
                begin: 0,
                end: mockRecommendationPercent,
              ),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6200EE)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dos clientes recomendam esse produto.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  // (E) Botão: Mostrar todas avaliações
  Widget _buildShowAllReviewsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          // TODO: Navegar para todas avaliações
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navegando para todas avaliações...')),
          );
        },
        child: Row(
          children: [
            Text(
              'Mostrar todas avaliações',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF6200EE),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF6200EE),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // (F) Seção: Comentários mais recentes (scroll horizontal)
  Widget _buildRecentReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Comentários mais recentes',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: mockReviews.length,
            itemBuilder: (context, index) {
              final review = mockReviews[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estrelas
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < (review['rating'] as int)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    // Nome do cliente
                    Text(
                      review['user'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Data
                    Text(
                      review['date'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Comentário
                    Expanded(
                      child: Text(
                        review['comment'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[300],
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
