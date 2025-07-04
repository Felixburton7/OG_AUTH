part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const EmailValueObject.pure(),
    this.password = const PasswordValueObject.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.successFromEmail = false,
    this.errorMessage,
  });

  final EmailValueObject email;
  final PasswordValueObject password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final bool successFromEmail;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        isValid,
        successFromEmail,
        errorMessage,
      ];

  LoginState copyWith({
    EmailValueObject? email,
    PasswordValueObject? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? successFromEmail,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      successFromEmail: successFromEmail ?? this.successFromEmail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// class LoginState extends Equatable {
//   const LoginState({
//     this.email = const EmailValueObject.pure(),
//     this.password = const PasswordValueObject.pure(),
//     this.status = FormzSubmissionStatus.initial,
//     this.isValid = false,
//     this.successFromEmail = false, // Added this flag
//     this.errorMessage,
//   });

//   final EmailValueObject email;
//   final PasswordValueObject password;
//   final FormzSubmissionStatus status;
//   final bool isValid;
//   final bool successFromEmail; // Flag to indicate success source
//   final String? errorMessage;

//   @override
//   List<Object> get props => [
//         email,
//         password,
//         status,
//         isValid,
//         successFromEmail, // Include in props for Equatable
//         if (errorMessage != null) errorMessage!,
//       ];

//   LoginState copyWith({
//     EmailValueObject? email,
//     PasswordValueObject? password,
//     FormzSubmissionStatus? status,
//     bool? isValid,
//     bool? successFromEmail,
//     String? errorMessage,
//   }) {
//     return LoginState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       status: status ?? this.status,
//       isValid: isValid ?? this.isValid,
//       successFromEmail: successFromEmail ?? this.successFromEmail,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }
// }

