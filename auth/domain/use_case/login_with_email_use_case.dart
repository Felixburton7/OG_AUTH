import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart';

@injectable
class LoginWithEmailUseCase extends UseCase<void, LoginWithEmailParams> {
  LoginWithEmailUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> execute(LoginWithEmailParams params) async {
    try {
      await _authRepository.loginWithEmail(params.email);
      return const Right(null); // Indicating success with void
    } catch (error) {
      return Left(Failure()); // Returning Failure in case of an error
    }
  }
}

class LoginWithEmailParams extends Equatable {
  const LoginWithEmailParams({
    required this.email,
  });

  final String email;

  @override
  List<Object?> get props => [email];
}
