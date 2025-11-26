# Implementation Plan

- [x] 1. Set up product providers and API integration


  - Create Riverpod providers for fetching products from different sections
  - Extend API service to support featured section filtering
  - _Requirements: 1.1, 2.2, 2.3, 7.1_



- [ ] 1.1 Create products provider file
  - Create `lib/features/products/presentation/providers/products_provider.dart`
  - Implement `highlightsProductsProvider` using FutureProvider
  - Implement `mainProductsProvider` using FutureProvider


  - _Requirements: 1.1, 2.2, 2.3_

- [x] 1.2 Extend API service for featured sections


  - Update `getProducts()` method in `lib/core/services/api_service.dart`
  - Add optional `featuredSection` parameter
  - Build query string with featured section filter
  - _Requirements: 1.1, 2.2, 2.3_



- [ ] 2. Create reusable product widgets
  - Build modern product card component
  - Create shimmer loading placeholder
  - Implement product section widget
  - _Requirements: 1.2, 1.3, 3.1, 9.1, 9.2, 9.3_

- [ ] 2.1 Create enhanced ProductCard widget
  - Update `lib/core/widgets/product_card.dart` to accept product data map


  - Extract product image from images array
  - Extract product price from priceTags array
  - Format price in Brazilian currency format (R$ X,XX)
  - Add CachedNetworkImage for product image with error handling


  - Implement tap gesture to navigate to product details
  - Apply modern styling (rounded corners, shadows, spacing)
  - _Requirements: 1.3, 3.1, 3.2, 3.3, 3.4, 3.5, 4.1, 4.3, 4.4, 5.1, 5.2, 9.1, 9.2, 9.3, 9.4_

- [ ] 2.2 Create ShimmerProductCard widget
  - Create `lib/core/widgets/shimmer_product_card.dart`
  - Implement shimmer animation using shimmer package
  - Match dimensions and layout of real ProductCard
  - _Requirements: 1.2_



- [ ] 2.3 Create ProductSection widget
  - Create `lib/features/home/presentation/widgets/product_section.dart`
  - Accept title, provider, and route as parameters
  - Build section header with title and "Ver mais" button


  - Watch product provider using ref.watch
  - Handle AsyncValue states (loading, error, data)
  - Display shimmer loading for loading state
  - Display error message with retry button for error state
  - Display horizontal scrollable list of products for data state
  - Display empty state when products list is empty


  - _Requirements: 1.2, 1.3, 1.4, 2.1, 2.4, 2.5, 6.1, 6.2, 6.3, 8.1_

- [ ] 3. Update HomePage to use real product data
  - Replace hardcoded mock data with provider watchers
  - Implement pull-to-refresh functionality


  - Add error handling and retry logic
  - _Requirements: 1.1, 1.3, 1.4, 1.5, 2.1, 2.2, 2.3, 6.1, 6.2, 6.3, 7.3_

- [x] 3.1 Replace "Produtos Recomendados" section with real data


  - Update `lib/features/home/presentation/pages/home_page.dart`
  - Remove hardcoded ListView.builder for "Produtos Recomendados"
  - Replace with ProductSection widget using highlightsProductsProvider
  - Pass section title "Produtos Recomendados"
  - Pass route "/products/highlights"



  - _Requirements: 1.1, 1.3, 2.1, 2.2, 2.5_

- [ ] 3.2 Replace "Mais Vendidos" section with real data
  - Remove hardcoded ListView.builder for "Mais Vendidos"
  - Replace with ProductSection widget using mainProductsProvider


  - Pass section title "Mais Vendidos"
  - Pass route "/products/main"
  - _Requirements: 1.1, 1.3, 2.1, 2.3, 2.5_



- [ ] 3.3 Implement pull-to-refresh functionality
  - Update RefreshIndicator onRefresh callback
  - Invalidate highlightsProductsProvider
  - Invalidate mainProductsProvider
  - Invalidate fetchBannersProvider (keep existing functionality)
  - _Requirements: 1.5, 7.3_


- [ ] 4. Add error handling and empty states
  - Implement error widgets with retry functionality
  - Create empty state components
  - Add proper error messages for different scenarios
  - _Requirements: 1.4, 2.4, 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ] 4.1 Create error state widget
  - Create `lib/core/widgets/error_state_widget.dart`
  - Display error icon and message
  - Add "Tentar Novamente" button


  - Accept onRetry callback
  - Handle different error types (network, server, unknown)
  - _Requirements: 1.4, 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ] 4.2 Create empty state widget
  - Create `lib/core/widgets/empty_state_widget.dart`
  - Display empty icon and message
  - Accept custom message parameter
  - _Requirements: 2.4_

- [ ] 5. Test and polish
  - Test on real devices with real API data
  - Verify image loading from Cloudinary
  - Test error scenarios (no internet, server error)
  - Test pull-to-refresh
  - Verify navigation to product details
  - Polish animations and transitions
  - _Requirements: All_

- [ ] 5.1 Manual testing checklist
  - Test product loading on app launch
  - Test pull-to-refresh functionality
  - Test navigation to product details and back
  - Test with no internet connection
  - Test with empty product sections
  - Test image loading and error states
  - Test on different screen sizes
  - Verify price formatting
  - Verify scroll position restoration
  - _Requirements: All_

- [ ] 6. Checkpoint - Ensure all functionality works
  - Ensure all tests pass, ask the user if questions arise.
