import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/banner/banner.dart' as entity;
import '../../../domain/usecases/banner/get_banners_usecase.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final GetBannersUseCase getBannersUseCase;

  BannerCubit({required this.getBannersUseCase}) : super(const BannerInitial());

  Future<void> fetchBanners(String storeId) async {
    emit(const BannerLoading());

    print('[BannerCubit] Fetching banners for storeId: $storeId');

    // Buscar banners da API real
    final result = await getBannersUseCase(GetBannersParams(storeId: storeId));

    result.fold(
      (failure) {
        print('[BannerCubit] Error: $failure');
        emit(BannerError(_mapFailureToMessage(failure)));
      },
      (banners) {
        print('[BannerCubit] Success: ${banners.length} banners loaded');
        emit(BannerLoaded(banners.cast()));
      },
    );
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Sem conexão com a internet';
      case ServerFailure:
        return 'Erro ao carregar banners';
      default:
        return 'Erro inesperado';
    }
  }
}
