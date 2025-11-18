import 'package:flutter/material.dart';
import '../../models/review_model.dart';

class ReviewsModal extends StatefulWidget {
  const ReviewsModal({Key? key}) : super(key: key);

  @override
  State<ReviewsModal> createState() => _ReviewsModalState();
}

class _ReviewsModalState extends State<ReviewsModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Mock data
  final ProductReviews mockProductReviews = ProductReviews(
    averageRating: 4.66,
    totalReviews: 671,
    recommendationPercent: 0.95,
    attributes: [
      ReviewAttribute(
        name: 'Tamanho',
        value: 3.0,
        labels: ['Pequeno', 'Justo', 'Na Medida', 'Largo', 'Muito Largo'],
      ),
      ReviewAttribute(
        name: 'Conforto',
        value: 4.5,
        labels: ['Ruim', 'Regular', 'Bom', 'Muito Bom', 'Excelente'],
      ),
      ReviewAttribute(
        name: 'Qualidade',
        value: 4.7,
        labels: ['Péssima', 'Ruim', 'Boa', 'Muito Boa', 'Excelente'],
      ),
      ReviewAttribute(
        name: 'Leveza',
        value: 4.2,
        labels: ['Pesado', 'Médio', 'Leve', 'Muito Leve', 'Super Leve'],
      ),
      ReviewAttribute(
        name: 'Custo Benefício',
        value: 4.8,
        labels: ['Péssimo', 'Ruim', 'Bom', 'Ótimo', 'Excelente'],
      ),
    ],
    reviews: [
      ReviewModel(
        userName: 'Edson',
        date: '17 de nov de 2025',
        rating: 5.0,
        comment: 'Ótimo produto. Recomendo! Qualidade excelente e chegou super rápido.',
        isPositive: true,
      ),
      ReviewModel(
        userName: 'Kelly',
        date: '12 de nov de 2025',
        rating: 5.0,
        comment: 'Top demais! Superou minhas expectativas.',
        isPositive: true,
      ),
      ReviewModel(
        userName: 'Carlos',
        date: '10 de nov de 2025',
        rating: 5.0,
        comment: 'Produto de altíssima qualidade. Vale muito a pena!',
        isPositive: true,
      ),
      ReviewModel(
        userName: 'Ana',
        date: '8 de nov de 2025',
        rating: 4.0,
        comment: 'Produto de qualidade. Vale a pena.',
        isPositive: true,
      ),
      ReviewModel(
        userName: 'João',
        date: '5 de nov de 2025',
        rating: 3.0,
        comment: 'Produto ok, mas esperava mais pela descrição.',
        isPositive: false,
      ),
      ReviewModel(
        userName: 'Maria',
        date: '3 de nov de 2025',
        rating: 5.0,
        comment: 'Adorei! Voltarei a comprar com certeza.',
        isPositive: true,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ReviewModel> get _filteredReviews {
    switch (_currentTabIndex) {
      case 0: // Todos
        return mockProductReviews.reviews;
      case 1: // Positivos
        return mockProductReviews.reviews.where((r) => r.isPositive).toList();
      case 2: // Negativos
        return mockProductReviews.reviews.where((r) => !r.isPositive).toList();
      default:
        return mockProductReviews.reviews;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Header fixo
          _buildHeader(),
          // Conteúdo scrollável
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Bloco de avaliação geral
                  _buildOverallRating(),
                  const SizedBox(height: 24),
                  // Bloco de recomendações
                  _buildRecommendationSection(),
                  const SizedBox(height: 32),
                  // Avaliação por atributo
                  _buildAttributesSection(),
                  const SizedBox(height: 32),
                  // Tabs e lista de comentários
                  _buildReviewsSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header com voltar e título
  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Avaliações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bloco de avaliação geral
  Widget _buildOverallRating() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avaliações dos clientes',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                mockProductReviews.averageRating.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < mockProductReviews.averageRating.floor()
                            ? Icons.star
                            : (index < mockProductReviews.averageRating ? Icons.star_half : Icons.star_border),
                        color: Colors.amber,
                        size: 28,
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Baseado em ${mockProductReviews.totalReviews} avaliações.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
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

  // Bloco de recomendações
  Widget _buildRecommendationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${(mockProductReviews.recommendationPercent * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              tween: Tween<double>(
                begin: 0,
                end: mockProductReviews.recommendationPercent,
              ),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6200EE)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Dos clientes recomendam esse produto.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // Seção de avaliação por atributos
  Widget _buildAttributesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: mockProductReviews.attributes.map((attr) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _buildAttributeItem(attr),
          );
        }).toList(),
      ),
    );
  }

  // Item de atributo individual
  Widget _buildAttributeItem(ReviewAttribute attribute) {
    final activeIndex = (attribute.value - 1).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          attribute.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        // Barra de 5 segmentos
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 8,
                margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
                decoration: BoxDecoration(
                  color: index == activeIndex
                      ? const Color(0xFF6200EE)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              attribute.labels[0],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              attribute.labels[2],
              style: TextStyle(
                fontSize: 12,
                fontWeight: activeIndex == 2 ? FontWeight.bold : FontWeight.normal,
                color: activeIndex == 2 ? Colors.black87 : Colors.grey[600],
              ),
            ),
            Text(
              attribute.labels[4],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Seção de reviews com tabs
  Widget _buildReviewsSection() {
    return Column(
      children: [
        // Tabs
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF6200EE),
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            indicatorColor: const Color(0xFF6200EE),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Todos'),
              Tab(text: 'Positivos'),
              Tab(text: 'Negativos'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Lista de comentários
        ..._filteredReviews.map((review) => _buildReviewItem(review)).toList(),
      ],
    );
  }

  // Item de comentário individual
  Widget _buildReviewItem(ReviewModel review) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Estrelas
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.floor() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  );
                }),
              ),
              const Spacer(),
              // Menu
              Icon(
                Icons.more_vert,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Nome do usuário
          Text(
            review.userName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          // Data
          Text(
            review.date,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 12),
          // Comentário
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
