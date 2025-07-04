
import '../entity/auth_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Stream<AuthState> getCurrentAuthState();
  AuthUserEntity? getLoggedInUser();
  Future<void> loginWithEmail(String email);
  Future<void> logout();

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  // Future<void> signUpExtraDetails(
  //   UserProfile userProfile,
  // );

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> nativeGoogleSignIn();
}
