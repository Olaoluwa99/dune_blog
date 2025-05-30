import 'package:dune_blog/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UserCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
