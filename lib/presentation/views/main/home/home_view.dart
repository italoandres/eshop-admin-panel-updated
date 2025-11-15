import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/config/flavor_config.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/services_locator.dart' as di;
import '../../../../domain/entities/product/product.dart';
import '../../../../domain/entities/store_settings/store_settings.dart';
import '../../../../domain/usecases/product/get_product_usecase.dart';
import '../../../../domain/usecases/store_settings/get_store_settings_usecase.dart';
import '../../../blocs/banner/banner_cubit.dart';
import '../../../blocs/filter/filter_cubit.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../widgets/alert_card.dart';
import '../../../widgets/banner_shimmer.dart';
import '../../../widgets/featured_products_section.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/quick_access_icons.dart';
import '../../../widgets/top_carousel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController scrollController = ScrollController();
  
  // Estado para seções destacadas
  final Map<String, List<Product>> _featuredSections = {
    'highlights': [],
    'newArrivals': [],
    'offers': [],
    'main': [],
  };
  
  final Map<String, bool> _sectionsLoading = {
    'highlights': true,
    'newArrivals': true,
    'offers': true,
    'main': true,
  };

  // Estado para configurações da loja
  StoreSettings? _storeSettings;
  bool _settingsLoading = true;

  void _scrollListener() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    double scrollPercentage = 0.7;
    if (currentScroll > (maxScroll * scrollPercentage)) {
      if (context.read<ProductBloc>().state is ProductLoaded) {
        context.read<ProductBloc>().add(const GetMoreProducts());
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
    // Buscar produtos ao iniciar a tela
    print('[HomeView] initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('[HomeView] Dispatching GetProducts event');
      context.read<ProductBloc>().add(const GetProducts(FilterProductParams()));
      _loadFeaturedSections();
      _loadStoreSettings();
    });
  }
  
  // Carregar produtos das seções destacadas
  void _loadFeaturedSections() async {
    final sections = ['highlights', 'newArrivals', 'offers', 'main'];
    
    for (final section in sections) {
      try {
        final useCase = di.sl<GetProductUseCase>();
        final result = await useCase(FilterProductParams(
          featuredSection: section,
          pageSize: 10,
        ));
        
        result.fold(
          (failure) {
            print('[HomeView] Erro ao carregar seção $section: $failure');
            if (mounted) {
              setState(() {
                _sectionsLoading[section] = false;
              });
            }
          },
          (productResponse) {
            if (mounted) {
              setState(() {
                _featuredSections[section] = productResponse.products;
                _sectionsLoading[section] = false;
              });
            }
          },
        );
      } catch (e) {
        print('[HomeView] Exceção ao carregar seção $section: $e');
        if (mounted) {
          setState(() {
            _sectionsLoading[section] = false;
          });
        }
      }
    }
  }

  // Carregar configurações da loja
  void _loadStoreSettings() async {
    try {
      final useCase = di.sl<GetStoreSettingsUseCase>();
      final result = await useCase(FlavorConfig.storeId);
      
      result.fold(
        (failure) {
          print('[HomeView] Erro ao carregar settings: $failure');
          if (mounted) {
            setState(() {
              _settingsLoading = false;
            });
          }
        },
        (settings) {
          print('[HomeView] ✅ Settings carregadas: ${settings.storeName}');
          print('[HomeView] 🖼️ Logo URL length: ${settings.logoUrl.length}');
          if (mounted) {
            setState(() {
              _storeSettings = settings;
              _settingsLoading = false;
            });
          }
        },
      );
    } catch (e) {
      print('[HomeView] ❌ Exceção ao carregar settings: $e');
      if (mounted) {
        setState(() {
          _settingsLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<BannerCubit>()..fetchBanners(FlavorConfig.storeId),
      child: Scaffold(
        body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).padding.top + 10),
                ),
                // Logo centralizada
                Padding(
                  padding: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                    top: 1,
                    bottom: 1,
                  ),
                  child: _settingsLoading
                      ? SizedBox(
                          height: 80,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                      : _buildLogo(),
                ),
                // Barra de busca compacta
                Padding(
                  padding: EdgeInsets.only(
                    top: 1.h,
                    left: 5.w,
                    right: 5.w,
                  ),
                  child: BlocBuilder<FilterCubit, FilterProductParams>(
                    builder: (context, state) {
                      return Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          autofocus: false,
                          controller: context.read<FilterCubit>().searchController,
                          onChanged: (val) => setState(() {}),
                          onSubmitted: (val) => context
                              .read<ProductBloc>()
                              .add(GetProducts(FilterProductParams(keyword: val))),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 22,
                            ),
                            suffixIcon: context
                                    .read<FilterCubit>()
                                    .searchController
                                    .text
                                    .isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      context
                                          .read<FilterCubit>()
                                          .searchController
                                          .clear();
                                      context.read<FilterCubit>().update(keyword: '');
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  )
                                : null,
                            border: InputBorder.none,
                            hintText: searchProductHint,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Ícones de acesso rápido
                  const QuickAccessIcons(),
                  SizedBox(height: 1.h),
                  // Banner Carousel
                  BlocBuilder<BannerCubit, BannerState>(
                    builder: (context, state) {
                      if (state is BannerLoading) {
                        return const BannerShimmer(height: 180);
                      } else if (state is BannerLoaded && state.banners.isNotEmpty) {
                        return TopCarousel(
                          banners: state.banners.cast(),
                          height: MediaQuery.of(context).size.height * 0.22,
                        );
                      } else if (state is BannerError) {
                        // Silenciosamente não mostrar nada em caso de erro
                        return const SizedBox.shrink();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  // Seções Destacadas
                  FeaturedProductsSection(
                    title: '🌟 Destaques',
                    sectionType: 'highlights',
                    products: _featuredSections['highlights'] ?? [],
                    isLoading: _sectionsLoading['highlights'] ?? true,
                    onSeeAll: () {
                      // TODO: Navegar para tela de produtos destacados
                    },
                  ),
                  FeaturedProductsSection(
                    title: '🆕 Lançamentos',
                    sectionType: 'newArrivals',
                    products: _featuredSections['newArrivals'] ?? [],
                    isLoading: _sectionsLoading['newArrivals'] ?? true,
                    onSeeAll: () {
                      // TODO: Navegar para tela de lançamentos
                    },
                  ),
                  FeaturedProductsSection(
                    title: '🔥 Ofertas',
                    sectionType: 'offers',
                    products: _featuredSections['offers'] ?? [],
                    isLoading: _sectionsLoading['offers'] ?? true,
                    onSeeAll: () {
                      // TODO: Navegar para tela de ofertas
                    },
                  ),
                  FeaturedProductsSection(
                    title: '⭐ Principal',
                    sectionType: 'main',
                    products: _featuredSections['main'] ?? [],
                    isLoading: _sectionsLoading['main'] ?? true,
                    onSeeAll: () {
                      // TODO: Navegar para tela principal
                    },
                  ),
                  // Título para todos os produtos
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    child: Row(
                      children: [
                        Text(
                          'Todos os Produtos',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Grid de Produtos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                  //Result Empty and No Error
                  if (state is ProductLoaded && state.products.isEmpty) {
                    return const AlertCard(
                      image: kEmpty,
                      message: productsNotFound,
                    );
                  }
                  //Error and no preloaded data
                  if (state is ProductError && state.products.isEmpty) {
                    if (state.failure is NetworkFailure) {
                      return AlertCard(
                        image: kNoConnection,
                        message: networkFailure,
                        onClick: () {
                          context.read<ProductBloc>().add(GetProducts(
                              FilterProductParams(
                                  keyword: context
                                      .read<FilterCubit>()
                                      .searchController
                                      .text)));
                        },
                      );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (state.failure is ServerFailure)
                            Image.asset(
                              'assets/status_image/internal-server-error.png',
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          if (state.failure is CacheFailure)
                            Image.asset(
                              'assets/status_image/no-connection.png',
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          Text(
                            productsNotFound,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          IconButton(
                              color: Colors.grey.shade600,
                              onPressed: () {
                                context.read<ProductBloc>().add(GetProducts(
                                    FilterProductParams(
                                        keyword: context
                                            .read<FilterCubit>()
                                            .searchController
                                            .text)));
                              },
                              icon: const Icon(Icons.refresh)),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          )
                        ],
                      ),
                    );
                  }
                  return GridView.builder(
                    itemCount: state.products.length +
                        ((state is ProductLoading) ? 10 : 0),
                    padding: EdgeInsets.only(
                        top: 18,
                        left: 20,
                        right: 20,
                        bottom: (80 + MediaQuery.of(context).padding.bottom)),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 20,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      if (state.products.length > index) {
                        return ProductCard(
                          product: state.products[index],
                        );
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade100,
                          highlightColor: Colors.white,
                          child: const ProductCard(),
                        );
                      }
                    },
                  );
                }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      ),
    );
  }

  Widget _buildLogo() {
    final logoUrl = _storeSettings?.logoUrl ?? '';
    final storeName = _storeSettings?.storeName ?? FlavorConfig.storeName;
    final logoPosition = _storeSettings?.logoPosition ?? 'center';

    Widget logoWidget;

    if (logoUrl.isNotEmpty) {
      try {
        // Remover o prefixo data:image/...;base64, se existir
        String base64String = logoUrl;
        if (logoUrl.contains(',')) {
          base64String = logoUrl.split(',').last;
        }
        
        // Remover espaços e quebras de linha
        base64String = base64String.replaceAll(RegExp(r'\s+'), '');
        
        print('[HomeView] 🖼️ Tentando decodificar logo (${base64String.length} chars)');
        
        final bytes = base64Decode(base64String);
        print('[HomeView] ✅ Logo decodificada (${bytes.length} bytes)');
        
        logoWidget = Image.memory(
          bytes,
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('[HomeView] ❌ Erro ao renderizar logo: $error');
            // Fallback para nome da loja
            return Text(
              storeName,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            );
          },
        );
      } catch (e, stackTrace) {
        print('[HomeView] ❌ Exceção ao processar logo: $e');
        print('[HomeView] ❌ Stack: $stackTrace');
        // Fallback para nome da loja
        logoWidget = Text(
          storeName,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        );
      }
    } else {
      print('[HomeView] ℹ️ Sem logo, mostrando nome da loja');
      // Mostrar nome da loja se não houver logo
      logoWidget = Text(
        storeName,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    }

    // Aplicar posicionamento
    if (logoPosition == 'left') {
      return Align(
        alignment: Alignment.centerLeft,
        child: logoWidget,
      );
    } else {
      return Center(
        child: logoWidget,
      );
    }
  }
}
