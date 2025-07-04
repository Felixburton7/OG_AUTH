part of 'signup_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.name = const NameValueObject.pure(),
    this.email = const EmailValueObject.pure(),
    this.password = const PasswordValueObject.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.isEmailStep = true, // Start with the email step
  });

  final NameValueObject name;
  final EmailValueObject email;
  final PasswordValueObject password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final bool isEmailStep;

  @override
  List<Object> get props =>
      [name, email, password, status, isValid, isEmailStep];

  SignUpState copyWith({
    NameValueObject? name,
    EmailValueObject? email,
    PasswordValueObject? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    bool? isEmailStep,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmailStep: isEmailStep ?? this.isEmailStep,
    );
  }
}
