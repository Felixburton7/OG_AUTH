// // reset_password_state.dart

// part of 'reset_password_cubit.dart';

// class ResetPasswordState extends Equatable {
//   const ResetPasswordState({
//     this.email = const EmailValueObject.pure(),
//     this.status = FormzStatus.pure,
//     this.errorMessage,
//   });

//   final EmailValueObject email;
//   final FormzStatus status;
//   final String? errorMessage;

//   ResetPasswordState copyWith({
//     EmailValueObject? email,
//     FormzStatus? status,
//     String? errorMessage,
//   }) {
//     return ResetPasswordState(
//       email: email ?? this.email,
//       status: status ?? this.status,
//       errorMessage: errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [email, status, errorMessage];
// }
