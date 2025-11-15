import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/store_settings/store_settings.dart';
import '../../repositories/store_settings_repository.dart';

class GetStoreSettingsUseCase implements UseCase<StoreSettings, String> {
  final StoreSettingsRepository repository;

  GetStoreSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, StoreSettings>> call(String storeId) async {
    return await repository.getStoreSettings(storeId);
  }
}
