import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// @injectable
// class LoginWithPasswordUseCase extends UseCase<void, LoginWithPasswordParams> {
//   LoginWithPasswordUseCase(this._authRepository);

//   final AuthRepository _authRepository;

//   @override
//   Future<Either<Failure, void>> execute(LoginWithPasswordParams params) async {
//     try {
//       await _authRepository.loginWithEmailPassword(
//         email: params.email,
//         password: params.password,
//       );
//       return const Right(null); // Return success as Right(void)
//     } catch (error) {
//       return Left(Failure()); // Return Failure in case of an error
//     }
//   }
// }

// class LoginWithPasswordParams extends Equatable {
//   const LoginWithPasswordParams({
//     required this.password,
//     required this.email,
//   });

//   final String password;
//   final String email;

//   @override
//   List<Object?> get props => [email, password];
// }
// login_with_password_use_case.dart
// login_with_password_use_case.dart
@injectable
class LoginWithPasswordUseCase
    implements UseCase<Unit, LoginWithPasswordParams> {
  final AuthRepository repository;

  LoginWithPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> execute(LoginWithPasswordParams params) async {
    try {
      await repository.loginWithEmailPassword(
        email: params.email,
        password: params.password,
      );
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('An unexpected error occurred.'));
    }
  }
}

class LoginWithPasswordParams extends Equatable {
  const LoginWithPasswordParams({
    required this.password,
    required this.email,
  });

  final String password;
  final String email;

  @override
  List<Object?> get props => [email, password];
}
