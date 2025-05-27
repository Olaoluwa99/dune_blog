import 'package:dune_blog/core/error/failure.dart';
import 'package:dune_blog/core/usecases/usecase.dart';
import 'package:dune_blog/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

import '../../../../core/common/entities/user.dart';

class CurrentUser implements UserCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
