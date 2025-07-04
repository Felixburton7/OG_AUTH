import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';


@injectable
class ProfileRemoteDataSource {
  final SupabaseClient _supabaseClient;

  ProfileRemoteDataSource(this._supabaseClient);

  // Fetch profile data from Supabase
  Future<UserProfileDTO> getProfile() async {
    try {
      final userId = _supabaseClient.auth.currentSession!.user.id;
      final data = await _supabaseClient
          .from('profiles')
          .select()
          .eq('profile_id', userId)
          .single();

      return UserProfileDTO.fromJson(data);
    } on PostgrestException catch (e) {
      if (e.message.contains('SocketException')) {
        throw Exception('No Internet Connection');
      } else {
        throw Exception('Database error: ${e.message}');
      }
    } on AuthException catch (error) {
      throw Exception('Authentication error: ${error.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  // Update profile data in Supabase
  Future<void> updateProfile(UserProfileDTO profile) async {
    try {
      final userId = _supabaseClient.auth.currentSession!.user.id;

      await _supabaseClient
          .from('profiles')
          .update(profile.toJson())
          .eq('profile_id', userId);
    } on PostgrestException catch (error) {
      throw Exception('Failed to update profile: ${error.code}');
    }
  }

  // Upload avatar to Supabase storage
  Future<String> uploadAvatar(File image) async {
    try {
      final userId = _supabaseClient.auth.currentSession!.user.id;
      final bytes = await image.readAsBytes();
      final fileExt = image.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;

      await _supabaseClient.storage.from('profiles').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: _getMimeType(fileExt)),
          );

      final publicUrl = await _supabaseClient.storage
          .from('profiles')
          .createSignedUrl(
              filePath, 60 * 60 * 24 * 365 * 10); // Valid for 10 years
      return publicUrl;
    } on StorageException catch (error) {
      throw Exception('Failed to upload image: ${error.message}');
    } catch (error) {
      throw Exception('Unexpected error: $error');
    }
  }

  // Helper method to get MIME type for file upload
  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }
}


// @Injectable(as: ProfileRepository)
// class SupabaseProfileRepository implements ProfileRepository {
//   final SupabaseClient _supabaseClient;

//   SupabaseProfileRepository(this._supabaseClient);

//   @override
//   Future<UserProfileDTO> getProfile() async {
//     try {
//       final userId = _supabaseClient.auth.currentSession!.user.id;
//       final data = await _supabaseClient
//           .from('profiles')
//           .select()
//           .eq('profile_id', userId)
//           .single();

//       return UserProfileDTO.fromJson(data);
//     } on PostgrestException catch (e) {
//       // Re-throw the custom error message if it's a unique constraint violation
//       if (e.message.contains('SocketException')) {
//         throw Exception('\nNo Internet');
//       } else {
//         throw Exception('Database error during league joining: ${e.message}');
//       }
//     } on AuthException catch (error) {
//       throw Exception('Authentication error: ${error.message}');
//     } catch (e) {
//       throw Exception('Unexpected error occurred during league joining: $e');
//     }
//   }

//   @override
//   Future<void> updateProfile(UserProfileDTO profile) async {
//     try {
//       final userId = _supabaseClient.auth.currentSession!.user.id;

//       await _supabaseClient
//           .from('profiles')
//           .update(profile.toJson())
//           .eq('profile_id', userId);
//     } on PostgrestException catch (error) {
//       throw Exception('Failed to update profile data: ${error.code}');
//     }
//   }

//   @override
//   Future<String> uploadAvatar(File image) async {
//     try {
//       final userId = _supabaseClient.auth.currentSession!.user.id;
//       final bytes = await image.readAsBytes();
//       final fileExt = image.path.split('.').last;
//       final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
//       final filePath = fileName;

//       await _supabaseClient.storage.from('profiles').uploadBinary(
//             filePath,
//             bytes,
//             fileOptions: FileOptions(contentType: _getMimeType(fileExt)),
//           );

//       final publicUrl = await _supabaseClient.storage
//           .from('profiles')
//           .createSignedUrl(
//               filePath, 60 * 60 * 24 * 365 * 10); // Valid for 10 years
//       return publicUrl;
//     } on StorageException catch (error) {
//       throw Exception('Failed to upload image: ${error.message}');
//     } catch (error) {
//       throw Exception('Unexpected error: $error');
//     }
//   }

//   String _getMimeType(String extension) {
//     switch (extension.toLowerCase()) {
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       case 'png':
//         return 'image/png';
//       case 'gif':
//         return 'image/gif';
//       default:
//         return 'application/octet-stream';
//     }
//   }
// }
