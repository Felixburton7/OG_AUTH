// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:formz/formz.dart';
// import 'package:injectable/injectable.dart';
// import 'package:panna_app/core/value_objects/auth/confirm_password_value_object.dart';
// import 'package:panna_app/features/account/settings/domain/use_case/update_password.dart';

// part 'update_forgot_password_state.dart';

// @injectable
// class UpdateForgotPasswordCubit extends Cubit<UpdateForgotPasswordState> {
//   final UpdatePasswordUseCase _updatePasswordUseCase;

//   UpdateForgotPasswordCubit(this._updatePasswordUseCase)
//       : super(const UpdateForgotPasswordState());

//   void passwordChanged(String value) {
//     final password = PasswordValueObject.dirty(value);
//     final confirmedPassword = ConfirmedPasswordValueObject.dirty(
//       password: password.value,
//       value: state.confirmedPassword.value,
//     );
//     emit(state.copyWith(
//       password: password,
//       confirmedPassword: confirmedPassword,
//       isValid: Formz.validate([password, confirmedPassword]),
//     ));
//   }

//   void confirmedPasswordChanged(String value) {
//     final confirmedPassword = ConfirmedPasswordValueObject.dirty(
//       password: state.password.value,
//       value: value,
//     );
//     emit(state.copyWith(
//       confirmedPassword: confirmedPassword,
//       isValid: Formz.validate([state.password, confirmedPassword]),
//     ));
//   }

//   Future<void> submitForm() async {
//     if (!state.isValid) return;

//     emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

//     final result = await _updatePasswordUseCase.execute(
//       UpdatePasswordUseCaseParams(password: state.password.value),
//     );

//     result.fold(
//       (failure) {
//         emit(state.copyWith(
//           status: FormzSubmissionStatus.failure,
//           errorMessage: failure.message ?? 'Failed to update password.',
//         ));
//       },
//       (_) {
//         emit(state.copyWith(status: FormzSubmissionStatus.success));
//         // Navigate back to login or signup page after password reset
//         emit(state.copyWith(navigateToLogin: true));
//       },
//     );
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/auth/password_value_object.dart';
import 'package:panna_app/features/account/settings/domain/use_case/update_forgot_password_usecase.dart';

part 'update_forgot_password_state.dart';

@injectable
class UpdateForgotPasswordCubit extends Cubit<UpdateForgotPasswordState> {
  final UpdateForgotPasswordUseCase _updateForgotPasswordUseCase;

  UpdateForgotPasswordCubit(this._updateForgotPasswordUseCase)
      : super(const UpdateForgotPasswordState());

  void passwordChanged(String value) {
    final password = PasswordValueObject.dirty(value);
    emit(state.copyWith(
      password: password,
      confirmPassword: state.confirmPassword.value.isNotEmpty
          ? ConfirmPasswordValueObject.dirty(
              password: value,
              value: state.confirmPassword.value,
            )
          : state.confirmPassword,
      isValid: Formz.validate([
        password,
        state.confirmPassword.value.isNotEmpty
            ? ConfirmPasswordValueObject.dirty(
                password: value,
                value: state.confirmPassword.value,
              )
            : state.confirmPassword,
      ]),
    ));
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = ConfirmPasswordValueObject.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      isValid: Formz.validate([state.password, confirmPassword]),
    ));
  }

  void setToken(String token) {
    emit(state.copyWith(token: token));
  }

  Future<void> submitForm() async {
    if (!state.isValid) return;
    if (state.token == null) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage:
              "No recovery token available. Try requesting another password reset."));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final result = await _updateForgotPasswordUseCase.execute(
        UpdateForgotPasswordParams(
          password: state.password.value,
          token: state.token!,
        ),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.message,
          ));
        },
        (_) {
          emit(state.copyWith(
            status: FormzSubmissionStatus.success,
            password: const PasswordValueObject.pure(),
            confirmPassword: const ConfirmPasswordValueObject.pure(),
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
