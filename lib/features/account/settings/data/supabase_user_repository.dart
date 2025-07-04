// import 'package:flutter/foundation.dart';
// import 'package:panna_app/core/constants/urls.dart';
// import 'package:panna_app/features/account/settings/domain/exception/change_email_address_exception.dart';
// import 'package:panna_app/features/account/settings/domain/exception/change_password_exception.dart';
// import 'package:panna_app/features/account/settings/domain/exception/update_password_exception.dart';
// import 'package:panna_app/features/account/settings/domain/repository/user_repository.dart';
// import 'package:injectable/injectable.dart';
// import 'package:supabase/supabase.dart';

// @Injectable(as: UserRepository)
// class SupabaseUserRepository implements UserRepository {
//   SupabaseUserRepository(this._supabaseAuth, this._functionsClient);

//   final GoTrueClient _supabaseAuth;
//   final FunctionsClient _functionsClient;

//   @override
//   Future<void> changeEmailAddress(String newEmailAddress) async {
//     try {
//       await _supabaseAuth.updateUser(
//         UserAttributes(email: newEmailAddress),
//         emailRedirectTo: kIsWeb ? null : Urls.changeEmailCallbackUrl,
//       );
//     } on AuthException catch (error) {
//       throw ChangeEmailAddressException(message: error.message);
//     }
//   }

//   @override
//   Future<void> resetPassword(String email) async {
//     try {
//       await _supabaseAuth.resetPasswordForEmail(
//         email,
//         redirectTo: kIsWeb ? null : Urls.resetPasswordCallbackUrl,
//       );
//     } on AuthException catch (error) {
//       throw ResetPasswordException(message: error.message);
//     }
//   }

//   @override
//   Future<void> updatePassword(String password) async {
//     try {
//       await _supabaseAuth.updateUser(
//         UserAttributes(password: password),
//       );

//     } on AuthException catch (error) {
//       throw UpdatePasswordException(message: error.message);
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:panna_app/core/constants/urls.dart';
import 'package:panna_app/features/account/settings/domain/exception/change_email_address_exception.dart';
import 'package:panna_app/features/account/settings/domain/exception/change_password_exception.dart';
import 'package:panna_app/features/account/settings/domain/exception/update_password_exception.dart';
import 'package:panna_app/features/account/settings/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase/supabase.dart';

@Injectable(as: UserRepository)
class SupabaseUserRepository implements UserRepository {
  SupabaseUserRepository(this._supabaseAuth, this._functionsClient);

  final GoTrueClient _supabaseAuth;
  final FunctionsClient _functionsClient;

  @override
  Future<void> changeEmailAddress(String newEmailAddress) async {
    try {
      await _supabaseAuth.updateUser(
        UserAttributes(email: newEmailAddress),
        emailRedirectTo: kIsWeb ? null : Urls.changeEmailCallbackUrl,
      );
    } on AuthException catch (error) {
      throw ChangeEmailAddressException(message: error.message);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseAuth.resetPasswordForEmail(
        email,
        redirectTo: kIsWeb ? null : Urls.resetPasswordCallbackUrl,
      );
    } on AuthException catch (error) {
      throw ResetPasswordException(message: error.message);
    }
  }

  @override
  Future<void> updatePassword(String password) async {
    try {
      await _supabaseAuth.updateUser(
        UserAttributes(password: password),
      );
    } on AuthException catch (error) {
      throw UpdatePasswordException(message: error.message);
    }
  }

  @override
  Future<void> updateForgotPassword(String password, String token) async {
    try {
      // Use the token to update the password
      await _supabaseAuth.recoverSession(token).then((response) async {
        // Get the new session
        final session = response.session;

        // Set the new session
        if (session != null) {
          await _supabaseAuth.setSession(session.refreshToken!);

          // Now update the password
          await _supabaseAuth.updateUser(
            UserAttributes(password: password),
          );
        } else {
          throw UpdatePasswordException(
              message: 'Invalid or expired recovery token');
        }
      });
    } on AuthException catch (error) {
      throw UpdatePasswordException(message: error.message);
    } catch (e) {
      throw UpdatePasswordException(message: e.toString());
    }
  }
}
