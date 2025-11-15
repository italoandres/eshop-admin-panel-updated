import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/store_settings/store_settings.dart';
import '../../domain/repositories/store_settings_repository.dart';
import '../data_sources/remote/store_settings_remote_data_source.dart';

class StoreSettingsRepositoryImpl implements StoreSettingsRepository {
  final StoreSettingsRemoteDataSource remoteDataSource;

  StoreSettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StoreSettings>> getStoreSettings(String storeId) async {
    try {
      final settings = await remoteDataSource.getStoreSettings(storeId);
      return Right(settings);
    } catch (e) {
      print('[StoreSettingsRepository] Erro: $e');
      return Left(ServerFailure());
    }
  }
}
