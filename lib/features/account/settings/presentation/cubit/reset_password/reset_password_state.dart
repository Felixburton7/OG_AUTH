part of 'reset_password_cubit.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.email = const EmailValueObject.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final EmailValueObject email;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  ResetPasswordState copyWith({
    EmailValueObject? email,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, status, errorMessage];
}
