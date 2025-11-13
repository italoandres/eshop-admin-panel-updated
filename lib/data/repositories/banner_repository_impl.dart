import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/banner/banner.dart';
import '../../domain/repositories/banner_repository.dart';
import '../data_sources/remote/banner_remote_data_source.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  BannerRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<Banner>>> getBanners(String storeId) async {
    // Verificar conexão com internet
    if (await connectionChecker.hasConnection) {
      try {
        final banners = await remoteDataSource.getBanners(storeId);
        return Right(banners);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
