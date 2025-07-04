import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class ImageUploadService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return imageFile != null ? File(imageFile.path) : null;
  }

  Future<String?> uploadProfileImage(File image) async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id;
      final String fileExt = image.path.split('.').last;
      final String fileName = 'profile.$fileExt';
      final imageBytes = await image.readAsBytes();

      final String filePath = '$userId/$fileName';

      await Supabase.instance.client.storage.from('profiles').uploadBinary(
          filePath, imageBytes,
          fileOptions: const FileOptions(upsert: true));

      final String publicUrl = Supabase.instance.client.storage
          .from('profiles')
          .getPublicUrl(filePath);

      return Uri.parse(publicUrl).replace(queryParameters: {
        't': DateTime.now().millisecondsSinceEpoch.toString()
      }).toString();
    } catch (e) {
      return null;
    }
  }

  // Function to upload the league image to the correct folder based on leagueId
  Future<String?> uploadImageLeague(File image, String leagueId) async {
    try {
      
      final String fileExt = image.path.split('.').last;
      final String fileName =
          'avatar.$fileExt'; // Naming the image file as avatar
      final imageBytes = await image.readAsBytes();

      // The file path will be based on the leagueId
      final String filePath = 'league_avatars/$leagueId/$fileName';

      await Supabase.instance.client.storage
          .from('league_avatars')
          .uploadBinary(filePath, imageBytes,
              fileOptions: const FileOptions(upsert: true));

      final String publicUrl = Supabase.instance.client.storage
          .from('league_avatars')
          .getPublicUrl(filePath);

      return Uri.parse(publicUrl).replace(queryParameters: {
        't': DateTime.now().millisecondsSinceEpoch.toString()
      }).toString();
    } catch (e) {
      
      return null;
    }
  }

  Future<String?> fetchLeagueAvatarUrl(String leagueId) async {
    try {
      const String fileName =
          'avatar.jpg'; // Assuming the avatar is named 'avatar.jpg'
      final String filePath = 'league_avatars/$leagueId/$fileName';

      final String publicUrl = Supabase.instance.client.storage
          .from('league_avatars')
          .getPublicUrl(filePath);

      return Uri.parse(publicUrl).replace(queryParameters: {
        't': DateTime.now().millisecondsSinceEpoch.toString()
      }).toString();
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProfileImage(String imageUrl) async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final response = await Supabase.instance.client
        .from('profiles')
        .update({'avatar_url': imageUrl}).eq('profile_id', userId);

    if (response == null || response.error != null) {
      return false;
    }
    return true;
  }
}
