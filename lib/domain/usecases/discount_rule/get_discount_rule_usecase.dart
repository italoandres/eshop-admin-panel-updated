import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/product/progressive_discount_rule.dart';
import '../../repositories/discount_rule_repository.dart';

class GetDiscountRuleUseCase {
  final DiscountRuleRepository repository;

  GetDiscountRuleUseCase(this.repository);

  Future<Either<Failure, ProgressiveDiscountRule?>> call(String productId) async {
    return await repository.getDiscountRuleByProduct(productId);
  }
}
