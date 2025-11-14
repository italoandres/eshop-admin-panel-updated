import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/product/progressive_discount_rule.dart';

abstract class DiscountRuleRepository {
  Future<Either<Failure, ProgressiveDiscountRule?>> getDiscountRuleByProduct(
      String productId);
}
