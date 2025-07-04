part of 'update_password_cubit.dart';

class UpdatePasswordState extends Equatable {
  const UpdatePasswordState({
    this.password = const PasswordValueObject.pure(),
    this.confirmedPassword = const ConfirmedPasswordValueObject.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final PasswordValueObject password;
  final ConfirmedPasswordValueObject confirmedPassword;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  UpdatePasswordState copyWith({
    PasswordValueObject? password,
    ConfirmedPasswordValueObject? confirmedPassword,
    bool? isValid,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return UpdatePasswordState(
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [password, confirmedPassword, isValid, status, errorMessage];
}
