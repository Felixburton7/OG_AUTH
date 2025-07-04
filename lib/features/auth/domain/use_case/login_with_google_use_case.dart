import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart';

@injectable
class LoginWithGoogleUseCase extends UseCase<void, NoParams> {
  LoginWithGoogleUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> execute(NoParams params) async {
    try {
      await _authRepository.nativeGoogleSignIn();
      return const Right(null); // Return success
    } catch (error) {
      return Left(Failure()); // Return failure in case of error
    }
  }
}
