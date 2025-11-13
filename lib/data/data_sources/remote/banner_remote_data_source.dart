import 'package:http/http.dart' as http;

import '../../../core/config/flavor_config.dart';
import '../../../core/error/exceptions.dart';
import '../../models/banner/banner_model.dart';

abstract class BannerRemoteDataSource {
  Future<List<BannerModel>> getBanners(String storeId);
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final http.Client client;

  BannerRemoteDataSourceImpl({required this.client});

  @override
  Future<List<BannerModel>> getBanners(String storeId) async {
    // Usa a URL do FlavorConfig
    final url = '${FlavorConfig.bannerApiUrl}/api/stores/$storeId/banners';
    
    print('[BannerRemoteDataSource] Fetching from: $url');
    
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('[BannerRemoteDataSource] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final banners = bannerModelListFromJson(response.body);
        print('[BannerRemoteDataSource] Parsed ${banners.length} banners');
        return banners;
      } else {
        print('[BannerRemoteDataSource] Server error: ${response.statusCode}');
        throw ServerException();
      }
    } catch (e) {
      print('[BannerRemoteDataSource] Exception: $e');
      throw ServerException();
    }
  }
}
