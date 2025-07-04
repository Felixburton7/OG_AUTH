// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:panna_app/core/use_cases/no_params.dart';
// import 'package:panna_app/core/value_objects/auth/email_value_object.dart';
// import 'package:panna_app/core/value_objects/auth/password_value_object.dart';
// import 'package:panna_app/features/auth/domain/exception/login_with_email_exception.dart';
// import 'package:panna_app/features/auth/domain/use_case/login_with_email_use_case.dart';
// import 'package:formz/formz.dart';
// import 'package:injectable/injectable.dart';
// import 'package:panna_app/features/auth/domain/use_case/login_with_google_use_case.dart';
// import 'package:panna_app/features/auth/domain/use_case/login_with_password_use_case.dart';
// import 'package:panna_app/features/auth/presentation/widget/login/buttons/login_google_button.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// part 'login_state.dart';

// @injectable
// class LoginCubit extends Cubit<LoginState> {
//   LoginCubit(this._loginWithEmailUseCase, this._loginWithPassWordUseCase,
//       this._loginWithGoogleUseCase)
//       : super(const LoginState());

//   final LoginWithGoogleUseCase _loginWithGoogleUseCase;
//   final LoginWithPasswordUseCase _loginWithPassWordUseCase;
//   final LoginWithEmailUseCase _loginWithEmailUseCase;

//   void emailChanged(String value) {
//     final email = EmailValueObject.dirty(value);
//     emit(state.copyWith(
//       email: email,
//       isValid: Formz.validate([email]),
//     ));
//   }

// // Takes in value from LoginWithPasswordInput context.read<LoginCubit>().passwordChanged(password);
//   void passwordChanged(String value) {
//     //
//     final password = PasswordValueObject.dirty(value);
//     emit(state.copyWith(
//       password: password,
//       isValid: Formz.validate([state.email, password]),
//     ));
//   }

//   void submitEmailForm() async {
//     if (!state.email.isValid) return;

//     emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

//     try {
//       await _loginWithEmailUseCase
//           .execute(LoginWithEmailParams(email: state.email.value));
//       emit(state.copyWith(
//           status: FormzSubmissionStatus.success, successFromEmail: true));
//     } on Exception {
//       emit(state.copyWith(
//         errorMessage: 'Failed to send email link',
//         status: FormzSubmissionStatus.failure,
//         successFromEmail: false,
//       ));
//     }
//   }
// // login_cubit.dart
// // login_cubit.dart

//   void submitPasswordForm() async {
//     if (!state.isValid) return;

//     emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
//     print('LoginCubit: Submission in progress');

//     try {
//       await _loginWithPassWordUseCase.execute(
//         LoginWithPasswordParams(
//           email: state.email.value,
//           password: state.password.value,
//         ),
//       );
//       emit(state.copyWith(
//         status: FormzSubmissionStatus.success,
//         successFromEmail: false,
//       ));
//       print('LoginCubit: Submission success');
//     } on AuthException catch (e) {
//       emit(state.copyWith(
//         errorMessage: 'Incorrect email or password. Please try again.',
//         status: FormzSubmissionStatus.failure,
//         successFromEmail: false,
//       ));
//       print('LoginCubit: Submission failure - AuthException');
//     } catch (e) {
//       emit(state.copyWith(
//         errorMessage: 'Incorrect email or password. Please try again.',
//         status: FormzSubmissionStatus.failure,
//         successFromEmail: false,
//       ));
//       print('LoginCubit: Submission failure - Generic Exception');
//     }
//   }

//   // void submitPasswordForm() async {
//   //   if (!state.isValid) return;

//   //   emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

//   //   try {
//   //     await _loginWithPassWordUseCase.execute(
//   //       LoginWithPasswordParams(
//   //           email: state.email.value, password: state.password.value),
//   //     );
//   //     emit(state.copyWith(
//   //         status: FormzSubmissionStatus.success, successFromEmail: false));
//   //   } on AuthException catch (e) {
//   //     emit(state.copyWith(
//   //       errorMessage:
//   //           e.message ?? 'Invalid login credentials, forgot password?',
//   //       status: FormzSubmissionStatus.failure,
//   //       successFromEmail: false,
//   //     ));
//   //   } on Exception catch (e) {
//   //     emit(state.copyWith(
//   //       errorMessage: 'Invalid login credentials, forgot password?',
//   //       status: FormzSubmissionStatus.failure,
//   //       successFromEmail: false,
//   //     ));
//   //   }
//   // }

//   void loginWithGoogle() async {
//     emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

//     try {
//       await _loginWithGoogleUseCase.execute(NoParams());
//       emit(state.copyWith(status: FormzSubmissionStatus.success));
//     } catch (e) {
//       emit(state.copyWith(
//         status: FormzSubmissionStatus.failure,
//         errorMessage: 'Failed to login with Google: ${e.toString()}',
//       ));
//     }
//   }
// }
// login_cubit.dart
// login_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/value_objects/auth/email_value_object.dart';
import 'package:panna_app/core/value_objects/auth/password_value_object.dart';
import 'package:panna_app/features/auth/domain/use_case/login_with_email_use_case.dart';
import 'package:panna_app/features/auth/domain/use_case/login_with_password_use_case.dart';
import 'package:panna_app/features/auth/domain/use_case/login_with_google_use_case.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this._loginWithEmailUseCase,
    this._loginWithPassWordUseCase,
    this._loginWithGoogleUseCase,
  ) : super(const LoginState());

  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final LoginWithPasswordUseCase _loginWithPassWordUseCase;
  final LoginWithEmailUseCase _loginWithEmailUseCase;

  void emailChanged(String value) {
    final email = EmailValueObject.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = PasswordValueObject.dirty(value);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
    ));
  }

  Future<void> submitEmailForm() async {
    if (!state.email.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    // print('LoginCubit: Email Submission in progress');

    final result = await _loginWithEmailUseCase.execute(
      LoginWithEmailParams(email: state.email.value),
    );

    result.fold(
      (failure) {
        // print('LoginCubit: Email Submission failure - ${failure.message}');
        emit(state.copyWith(
          errorMessage: failure.message,
          status: FormzSubmissionStatus.failure,
          successFromEmail: false,
        ));
      },
      (_) {
        print('LoginCubit: Email Submission success');
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          successFromEmail: true,
        ));
      },
    );
  }

  Future<void> submitPasswordForm() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    print('LoginCubit: Password Submission in progress');

    final result = await _loginWithPassWordUseCase.execute(
      LoginWithPasswordParams(
        email: state.email.value,
        password: state.password.value,
      ),
    );

    result.fold(
      (failure) {
        print('LoginCubit: Password Submission failure - ${failure.message}');
        emit(state.copyWith(
          errorMessage: failure.message,
          status: FormzSubmissionStatus.failure,
          successFromEmail: false,
        ));
      },
      (_) {
        print('LoginCubit: Password Submission success');
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          successFromEmail: false,
        ));
      },
    );
  }

  // Future<void> loginWithGoogle() async {
  //   emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
  //   print('LoginCubit: Google Login in progress');

  //   try {
  //     await _loginWithGoogleUseCase.execute(NoParams());
  //     emit(state.copyWith(status: FormzSubmissionStatus.success));
  //     print('LoginCubit: Google Login success');
  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: FormzSubmissionStatus.failure,
  //       errorMessage: 'Failed to login with Google: ${e.toString()}',
  //     ));
  //     print('LoginCubit: Google Login failure - ${e.toString()}');
  //   }
  // }
}
