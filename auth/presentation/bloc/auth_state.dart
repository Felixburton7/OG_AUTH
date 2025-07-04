part of 'auth_bloc.dart';

abstract class AuthBlocState extends Equatable {
  const AuthBlocState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthBlocState {
  const AuthInitial();
}

class AuthUserAuthenticated extends AuthBlocState {
  final AuthUserEntity user;

  const AuthUserAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthPasswordRecovery extends AuthBlocState {
  final AuthUserEntity user;

  const AuthPasswordRecovery(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUserUnauthenticated extends AuthBlocState {
  const AuthUserUnauthenticated();
}

// sealed class AuthState extends Equatable {
//   const AuthState();

//   @override
//   List<Object> get props => [];
// }

// class AuthInitial extends AuthState {
//   const AuthInitial();
// }

// class AuthUserAuthenticated extends AuthState {
//   final AuthUserEntity user;
//   final supabase_auth.AuthChangeEvent? authEvent;

//   const AuthUserAuthenticated(this.user, [this.authEvent]);

//   @override
//   List<Object?> get props => [user, authEvent];
// }

// // class AuthUserAuthenticated extends AuthState {
// //   const AuthUserAuthenticated(
// //     this.user,
// //   );

// //   final AuthUserEntity user;

// //   @override
// //   List<Object> get props => [
// //         user,
// //       ];
// // }

// class AuthUserUnauthenticated extends AuthState {
//   const AuthUserUnauthenticated();
// }
