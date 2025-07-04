import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:panna_app/core/constants/urls.dart';
import 'package:panna_app/features/auth/data/mapper/auth_mapper.dart';
import 'package:panna_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:panna_app/features/auth/domain/exception/login_with_email_exception.dart';
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// @Injectable(as: AuthRepository)
// class SupabaseAuthRepository implements AuthRepository {
//   SupabaseAuthRepository(this._supabaseAuth, this._supabaseClient);

//   final GoTrueClient _supabaseAuth;
//   final SupabaseClient _supabaseClient;

//   @override
//   Stream<AuthState> getCurrentAuthState() {
//     return _supabaseAuth.onAuthStateChange.map(
//       (authState) => authState,
//     );
//   }

//   @override
//   AuthUserEntity? getLoggedInUser() {
//     return _supabaseAuth.currentUser
//         ?.toUserEntity(); //Map supabaseAuth to a UserEntity.
//   }

// // LOGIN
// // supabase_auth_repository.dart
//   @override
//   Future<void> loginWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await _supabaseAuth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//       // If signInWithPassword doesn't throw, login is successful.
//       // No need to throw an exception here.
//     } on AuthException catch (error) {
//       // Throw a custom AuthException with a meaningful message
//       throw AuthException(error.message);
//     } catch (e) {
//       throw Exception('An unexpected error occurred');
//     }
//   }

//   // @override
//   // Future<void> loginWithEmailPassword({
//   //   required String email,
//   //   required String password,
//   // }) async {
//   //   try {
//   //     await _supabaseAuth.signInWithPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //   } on AuthException catch (error) {
//   //     throw AuthException(error.message, statusCode: error.statusCode);
//   //   } catch (e) {
//   //     throw Exception('An unexpected error occurred');
//   //   }
//   // }

//   @override
//   Future<void> logout() async {
//     await _supabaseAuth.signOut();
//   }

// //SIGNUP
//   @override
//   Future<void> signUpWithEmailPassword({
//     // required String name,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await Supabase.instance.client.auth.signUp(
//         password: password,
//         email: email,
//         emailRedirectTo: Urls.signUpCallbackUrl,

//         // data: {
//         //   'name': name,
//         // },
//       );

//       if (response.user == null) {
//         throw Exception('User is null!');
//       }
//     } on AuthException catch (error) {
//       throw AuthException(error.message, statusCode: error.statusCode);
//     } catch (e) {
//       throw Exception('An unexpected error occurred');
//     }
//   }

//   @override
//   Future<void> _nativeGoogleSignIn() async {
//     /// TODO: update the Web client ID with your own.
//     ///
//     /// Web Client ID that you registered with Google Cloud.
//     const webClientId =
//         '241375159306-e0ld0g4rvqdki97itlm30nbfac94vt1m.apps.googleusercontent.com';

//     /// TODO: update the iOS client ID with your own.
//     ///
//     /// iOS Client ID that you registered with Google Cloud.
//     const iosClientId =
//         '241375159306-1pil0f8e7knerh4m5k005q1psrc21n5b.apps.googleusercontent.com';

//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       clientId: iosClientId,
//       serverClientId: webClientId,
//     );
//     final googleUser = await googleSignIn.signIn();
//     final googleAuth = await googleUser!.authentication;
//     final accessToken = googleAuth.accessToken;
//     final idToken = googleAuth.idToken;

//     if (accessToken == null) {
//       throw 'No Access Token found.';
//     }
//     if (idToken == null) {
//       throw 'No ID Token found.';
//     }

//     await _supabaseClient.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );
//   }

//   // Future<void> signUpExtraDetails({
//   //   // required String name,
//   //   required String email,
//   //   required String password,
//   // }) async {
//   //   try {
//   //     final response = await Supabase.instance.client.auth.signUp(
//   //       password: password,
//   //       email: email,
//   //       // data: {
//   //       //   'name': name,
//   //       // },
//   //     );

//   //     if (response.user == null) {
//   //       throw Exception('User is null!');
//   //     }
//   //   } on AuthException catch (error) {
//   //     throw AuthException(error.message, statusCode: error.statusCode);
//   //   } catch (e) {
//   //     throw Exception('An unexpected error occurred');
//   //   }
//   // }

// // To potentially implement later
//   @override
//   Future<void> loginWithEmail(String email) async {
//     try {
//       await _supabaseAuth.signInWithOtp(
//         email: email,
//         emailRedirectTo: kIsWeb ? null : Urls.loginCallbackUrl,
//       );
//     } on AuthException catch (error) {
//       throw LoginWithEmailException(error.message);
//     }
//   }

//   @override
//   Future<void> nativeGoogleSignIn() async {
//     /// TODO: update the Web client ID with your own.
//     ///
//     /// Web Client ID that you registered with Google Cloud.
//     const webClientId =
//         '241375159306-e0ld0g4rvqdki97itlm30nbfac94vt1m.apps.googleusercontent.com';

//     /// TODO: update the iOS client ID with your own.
//     ///
//     /// iOS Client ID that you registered with Google Cloud.
//     const iosClientId =
//         '241375159306-1pil0f8e7knerh4m5k005q1psrc21n5b.apps.googleusercontent.com';

//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       clientId: iosClientId,
//       serverClientId: webClientId,
//     );
//     final googleUser = await googleSignIn.signIn();
//     final googleAuth = await googleUser!.authentication;
//     final accessToken = googleAuth.accessToken;
//     final idToken = googleAuth.idToken;

//     if (accessToken == null) {
//       throw 'No Access Token found.';
//     }
//     if (idToken == null) {
//       throw 'No ID Token found.';
//     }

//     await _supabaseClient.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );
//   }
// }

@Injectable(as: AuthRepository)
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._supabaseAuth, this._supabaseClient);

  final GoTrueClient _supabaseAuth;
  final SupabaseClient _supabaseClient;

  @override
  Stream<AuthState> getCurrentAuthState() {
    return _supabaseAuth.onAuthStateChange.map(
      (authState) => authState,
    );
  }

  @override
  AuthUserEntity? getLoggedInUser() {
    return _supabaseAuth.currentUser
        ?.toUserEntity(); // Map supabaseAuth to a UserEntity.
  }

  // LOGIN
  @override
  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseAuth.signInWithPassword(
        email: email,
        password: password,
      );
      // Successful login; no action needed.
      // Do not throw an exception here.
    } on AuthException catch (error) {
      // Throw a custom AuthException with a meaningful message
      throw AuthException(error.message);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<void> logout() async {
    await _supabaseAuth.signOut();
  }

  // SIGNUP
  @override
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        password: password,
        email: email,
        emailRedirectTo: Urls.signUpCallbackUrl,
      );

      if (response.user == null) {
        throw Exception('User is null!');
      }
    } on AuthException catch (error) {
      throw AuthException(error.message, statusCode: error.statusCode);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<void> loginWithEmail(String email) async {
    try {
      await _supabaseAuth.signInWithOtp(
        email: email,
        emailRedirectTo: kIsWeb ? null : Urls.loginCallbackUrl,
      );
    } on AuthException catch (error) {
      throw LoginWithEmailException(error.message);
    }
  }

  @override
  Future<void> nativeGoogleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '241375159306-e0ld0g4rvqdki97itlm30nbfac94vt1m.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '241375159306-1pil0f8e7knerh4m5k005q1psrc21n5b.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await _supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
