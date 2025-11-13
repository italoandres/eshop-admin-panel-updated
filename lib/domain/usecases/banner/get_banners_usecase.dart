import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/banner/banner.dart';
import '../../repositories/banner_repository.dart';

class GetBannersUseCase implements UseCase<List<Banner>, GetBannersParams> {
  final BannerRepository repository;

  GetBannersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Banner>>> call(GetBannersParams params) async {
    // Log para telemetria
    print('[GetBannersUseCase] Fetching banners for storeId: ${params.storeId}');
    
    final result = await repository.getBanners(params.storeId);
    
    result.fold(
      (failure) => print('[GetBannersUseCase] Error: $failure'),
      (banners) => print('[GetBannersUseCase] Success: ${banners.length} banners loaded'),
    );
    
    return result;
  }
}

class GetBannersParams extends Equatable {
  final String storeId;

  const GetBannersParams({required this.storeId});

  @override
  List<Object?> get props => [storeId];
}
