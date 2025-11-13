import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/banner/banner.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<Banner>>> getBanners(String storeId);
}
