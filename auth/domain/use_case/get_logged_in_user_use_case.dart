import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart';

@injectable
class GetLoggedInUserUseCase extends UseCase<AuthUserEntity?, NoParams> {
  GetLoggedInUserUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, AuthUserEntity?>> execute(NoParams params) async {
    try {
      final user = _authRepository.getLoggedInUser();
      return Right(user); // Wrap successful user retrieval in Right
    } catch (error) {
      return Left(Failure()); // Return appropriate Failure
    }
  }
}
