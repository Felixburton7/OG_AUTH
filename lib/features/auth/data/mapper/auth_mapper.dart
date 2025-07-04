import 'package:panna_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Converts
//Mapping/Transformation:
//This extension method simplifies the process of transforming a User object ( third-party library Supabase)
//into a custom AuthUserEntity object that your application might use internally.

extension AuthMapper on User {
  AuthUserEntity toUserEntity() {
    return AuthUserEntity(
      id: id,
      email: email!,
    );
  }
}

// Used in supabase_auth_repository -
// @override
// AuthUserEntity? getLoggedInUser() {
//   return _supabaseAuth.currentUser?.toUserEntity();
// }
