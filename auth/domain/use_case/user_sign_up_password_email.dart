import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class SignUpWithPasswordUseCase
    extends UseCase<void, SignUpWithPasswordParams> {
  SignUpWithPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> execute(SignUpWithPasswordParams params) async {
    try {
      await _authRepository.signUpWithEmailPassword(
        email: params.email,
        password: params.password,
      );
      return const Right(null); // Return success with Right(null)
    } on AuthException catch (e) {
      return Left(Failure(e.message)); // Return failure with message
    } catch (e) {
      return Left(Failure()); // Handle any unexpected errors
    }
  }
}

class SignUpWithPasswordParams extends Equatable {
  const SignUpWithPasswordParams({
    required this.password,
    required this.email,
  });

  final String password;
  final String email;

  @override
  List<Object?> get props => [email, password];
}
