import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/product/progressive_discount_rule.dart';
import '../../domain/repositories/discount_rule_repository.dart';
import '../data_sources/remote/discount_rule_remote_data_source.dart';

class DiscountRuleRepositoryImpl implements DiscountRuleRepository {
  final DiscountRuleRemoteDataSource remoteDataSource;

  DiscountRuleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProgressiveDiscountRule?>> getDiscountRuleByProduct(
      String productId) async {
    try {
      final rule = await remoteDataSource.getDiscountRuleByProduct(productId);
      return Right(rule);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
