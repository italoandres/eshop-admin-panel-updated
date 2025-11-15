import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/store_settings/store_settings.dart';

abstract class StoreSettingsRepository {
  Future<Either<Failure, StoreSettings>> getStoreSettings(String storeId);
}
