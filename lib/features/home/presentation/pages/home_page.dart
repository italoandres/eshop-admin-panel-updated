import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../banners/presentation/widgets/banner_carousel.dart';
import '../../../banners/presentation/providers/banner_provider.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../../core/config/store_config_provider.dart';
import '../widgets/quick_access_icons.dart';
import '../widgets/main_drawer.dart';
import '../widgets/product_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  // TODO: Buscar stories da API
  final bool hasStories = true; // TODO: Vir da API

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (hasStories) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onStoriesPressed() {
    debugPrint('Stories clicked');
    // TODO: Navegar para tela de visualização de stories
  }

  @override
  Widget build(BuildContext context) {
    final storeConfig = ref.watch(storeConfigProvider).value;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // Scaffold com AppBar e conteúdo
        Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            title: null,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  // TODO: Navegar para carrinho
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).logout();
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fetchBannersProvider);
              ref.invalidate(highlightsProductsProvider);
              ref.invalidate(mainProductsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.only(top: 10, bottom: 16),
              children: [
                // Carrossel de banners
                const BannerCarousel(),
                const SizedBox(height: 24),

                // Ícones de acesso rápido
                const QuickAccessIcons(),
                const SizedBox(height: 32),

                // SEÇÃO 1: Produtos Recomendados
                // TODO: Trocar para highlightsProductsProvider quando produtos forem marcados
                ProductSection(
                  title: 'Produtos Recomendados',
                  productsProvider: allProductsProvider,
                  sectionRoute: '/products/all',
                ),
                const SizedBox(height: 32),

                // SEÇÃO 2: Mais Vendidos
                // TODO: Trocar para mainProductsProvider quando produtos forem marcados
                ProductSection(
                  title: 'Mais Vendidos',
                  productsProvider: allProductsProvider,
                  sectionRoute: '/products/all',
                ),
              ],
            ),
          ),
          drawer: const MainDrawer(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
                label: 'Categorias',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart),
                label: 'Carrinho',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ),

        // Círculo de stories POR CIMA de tudo - 90% dentro da AppBar roxa
        Positioned(
          top: statusBarHeight + 10, // StatusBar + 10px do topo da AppBar
          left: 0,
          right: 0,
          child: Center(
            child: _buildStoriesCircle(storeConfig?.logoUrl),
          ),
        ),
      ],
    );
  }

  Widget _buildStoriesCircle(String? logoUrl) {
    const double circleSize = 100.0;
    const double borderWidth = 4.0;

    // Círculo interno (SEMPRE VISÍVEL, SEM ANIMAÇÃO)
    Widget innerCircle = Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: logoUrl != null
              ? CachedNetworkImage(
                  imageUrl: logoUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.store,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : Icon(
                  Icons.store,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
        ),
      ),
    );

    // Se TEM stories: adiciona BORDA ANIMADA (opacity, não scale)
    if (hasStories) {
      return GestureDetector(
        onTap: _onStoriesPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Borda gradiente ANIMADA (pulsa opacity)
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: circleSize + borderWidth * 2,
                    height: circleSize + borderWidth * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00BCD4), // Ciano
                          Color(0xFF9C27B0), // Roxo
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00BCD4).withOpacity(0.5),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Círculo interno FIXO (não anima)
            innerCircle,
          ],
        ),
      );
    }

    // Se NÃO tem stories: apenas borda cinza
    return GestureDetector(
      onTap: _onStoriesPressed,
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: innerCircle,
      ),
    );
  }
}
