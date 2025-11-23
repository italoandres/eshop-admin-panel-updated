import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../domain/models/banner_model.dart';

/// Provider para operações admin de banners
class BannerAdminNotifier extends StateNotifier<AsyncValue<List<BannerModel>>> {
  final ApiService _apiService;

  BannerAdminNotifier(this._apiService) : super(const AsyncValue.loading()) {
    loadBanners();
  }

  /// Carrega todos os banners (incluindo inativos)
  Future<void> loadBanners() async {
    state = const AsyncValue.loading();
    try {
      final banners = await _apiService.getAllBanners(ApiConfig.defaultStoreId);
      state = AsyncValue.data(banners);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Cria um novo banner
  Future<void> createBanner({
    required String title,
    required String imageUrl,
    required String targetUrl,
    int order = 0,
    bool active = true,
    DateTime? startAt,
    DateTime? endAt,
  }) async {
    try {
      final bannerData = {
        'title': title,
        'imageUrl': imageUrl,
        'targetUrl': targetUrl,
        'order': order,
        'active': active,
        if (startAt != null) 'startAt': startAt.toIso8601String(),
        if (endAt != null) 'endAt': endAt.toIso8601String(),
      };

      await _apiService.createBanner(ApiConfig.defaultStoreId, bannerData);
      
      // Recarrega a lista após criar
      await loadBanners();
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza um banner existente
  Future<void> updateBanner({
    required String bannerId,
    required String title,
    required String imageUrl,
    required String targetUrl,
    int order = 0,
    bool active = true,
    DateTime? startAt,
    DateTime? endAt,
  }) async {
    try {
      final bannerData = {
        'title': title,
        'imageUrl': imageUrl,
        'targetUrl': targetUrl,
        'order': order,
        'active': active,
        if (startAt != null) 'startAt': startAt.toIso8601String(),
        if (endAt != null) 'endAt': endAt.toIso8601String(),
      };

      await _apiService.updateBanner(
        ApiConfig.defaultStoreId,
        bannerId,
        bannerData,
      );
      
      // Recarrega a lista após atualizar
      await loadBanners();
    } catch (e) {
      rethrow;
    }
  }

  /// Deleta um banner
  Future<void> deleteBanner(String bannerId) async {
    try {
      await _apiService.deleteBanner(ApiConfig.defaultStoreId, bannerId);
      
      // Recarrega a lista após deletar
      await loadBanners();
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider do notifier
final bannerAdminProvider =
    StateNotifierProvider<BannerAdminNotifier, AsyncValue<List<BannerModel>>>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    return BannerAdminNotifier(apiService);
  },
);
