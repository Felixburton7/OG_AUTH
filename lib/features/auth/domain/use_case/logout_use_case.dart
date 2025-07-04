import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart';

@injectable
class LogoutUseCase extends UseCase<void, NoParams> {
  LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> execute(NoParams params) async {
    try {
      await _authRepository.logout();
      return const Right(null); // Indicating success with Right(null)
    } catch (error) {
      return Left(Failure()); // Returning Failure in case of an error
    }
  }
}
