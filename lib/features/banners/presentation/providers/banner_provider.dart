import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/repositories/banner_repository.dart';
import '../../domain/models/banner_model.dart';

// Provider do repositório
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return BannerRepository(dioClient);
});

// Provider que busca os banners
final fetchBannersProvider = FutureProvider<List<BannerModel>>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  return await repository.fetchBanners();
});

// Provider para banner específico
final fetchBannerByIdProvider = FutureProvider.family<BannerModel, String>(
  (ref, id) async {
    final repository = ref.watch(bannerRepositoryProvider);
    return await repository.fetchBannerById(id);
  },
);
