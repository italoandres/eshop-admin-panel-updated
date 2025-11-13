import '../../domain/entities/banner/banner.dart' as entity;

// Banners mockados para teste (remover depois que a API estiver pronta)
final List<entity.Banner> mockBanners = [
  entity.Banner(
    id: '1',
    storeId: 'store_001',
    title: 'Black Friday - 100 Milhões em Cupons',
    imageUrl:
        'https://http2.mlstatic.com/D_NQ_NP_2X_933830-MLA80046906138_102024-OO.webp',
    targetUrl: 'https://www.mercadolivre.com.br/ofertas',
    order: 1,
    active: true,
  ),
  entity.Banner(
    id: '2',
    storeId: 'store_001',
    title: 'Meli+ Mega - 4 Streamings',
    imageUrl:
        'https://http2.mlstatic.com/D_NQ_NP_2X_933830-MLA80046906138_102024-OO.webp',
    targetUrl: 'https://www.mercadolivre.com.br/meli-mais',
    order: 2,
    active: true,
  ),
  entity.Banner(
    id: '3',
    storeId: 'store_001',
    title: 'Ofertas Especiais',
    imageUrl:
        'https://http2.mlstatic.com/D_NQ_NP_2X_933830-MLA80046906138_102024-OO.webp',
    targetUrl: 'https://www.mercadolivre.com.br/ofertas',
    order: 3,
    active: true,
  ),
];
