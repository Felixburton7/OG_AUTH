// update_forgot_password_state.dart
part of 'update_forgot_password_cubit.dart';

class UpdateForgotPasswordState extends Equatable {
  final PasswordValueObject password;
  final ConfirmedPasswordValueObject
      confirmedPassword; // ← rename and correct type
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final String? token;

  const UpdateForgotPasswordState({
    this.password = const PasswordValueObject.pure(),
    this.confirmedPassword =
        const ConfirmedPasswordValueObject.pure(), // ← corrected
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.token,
  });

  UpdateForgotPasswordState copyWith({
    PasswordValueObject? password,
    ConfirmedPasswordValueObject? confirmedPassword, // ← corrected
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    String? token,
  }) {
    return UpdateForgotPasswordState(
      password: password ?? this.password,
      confirmedPassword:
          confirmedPassword ?? this.confirmedPassword, // ← corrected
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
        password,
        confirmedPassword,
        status,
        isValid,
        errorMessage,
        token,
      ];
}
