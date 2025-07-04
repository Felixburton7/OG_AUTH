part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class AuthInitialCheckRequested extends AuthEvent {
  const AuthInitialCheckRequested();
}

class AuthOnCurrentUserChanged extends AuthEvent {
  final AuthUserEntity? user;
  final supabase_auth.AuthChangeEvent? authEvent;

  const AuthOnCurrentUserChanged(this.user, this.authEvent);

  @override
  List<Object?> get props => [user, authEvent];
}


class AuthLogoutButtonPressed extends AuthEvent {
  const AuthLogoutButtonPressed();
}

class AuthClearProfile extends AuthEvent {
  const AuthClearProfile();
}
