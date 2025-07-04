// import 'package:fpdart/fpdart.dart';
// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart';
// import 'package:panna_app/core/error/failures.dart';
// import 'package:panna_app/core/use_cases/use_case.dart';
// import 'package:panna_app/features/account/settings/domain/exception/update_password_exception.dart';
// import 'package:panna_app/features/account/settings/domain/repository/user_repository.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// @injectable
// class UpdateForgotPasswordUseCase
//     extends UseCase<void, UpdateForgotPasswordUseCaseParams> {
//   UpdateForgotPasswordUseCase(this._userRepository);

//   final UserRepository _userRepository;

//   @override
//   Future<Either<Failure, void>> execute(
//       UpdateForgotPasswordUseCaseParams params) async {
//     try {
//       // First, update the user's password
//       await _userRepository.updatePassword(params.password);

//       // Dispatch logout event using AuthBloc after updating password
//       await Supabase.instance.client.auth.signOut();

//       return const Right(null);
//     } on UpdatePasswordException catch (e) {
//       return Left(Failure(e.message));
//     } catch (e) {
//       return Left(Failure('An unknown error occurred.'));
//     }
//   }
// }

// class UpdateForgotPasswordUseCaseParams {
//   UpdateForgotPasswordUseCaseParams(
//       {required this.password, required this.context});

//   final String password;
//   final BuildContext context; // Pass the context to access AuthBloc
// }

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/account/settings/domain/exception/update_password_exception.dart';
import 'package:panna_app/features/account/settings/domain/repository/user_repository.dart';

class UpdateForgotPasswordParams {
  final String password;
  final String token;

  UpdateForgotPasswordParams({
    required this.password,
    required this.token,
  });
}

@injectable
class UpdateForgotPasswordUseCase {
  final UserRepository _userRepository;

  UpdateForgotPasswordUseCase(this._userRepository);

  Future<Either<Failure, void>> execute(
      UpdateForgotPasswordParams params) async {
    try {
      await _userRepository.updateForgotPassword(
        params.password,
        params.token,
      );
      return const Right(null);
    } on UpdatePasswordException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
