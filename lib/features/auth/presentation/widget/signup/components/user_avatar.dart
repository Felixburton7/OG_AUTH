import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {super.key,
      required this.imageUrl,
      required this.onUpload,
      required this.supabase});

  final SupabaseClient supabase;
  final String? imageUrl;
  final void Function(String imageUrl) onUpload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.amber,
                  child: const Center(child: Text('No ')),
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              // Pick an image.
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);

              if (image == null) {
                return;
              }
              final imageBytes = await image.readAsBytes();
              final userId = supabase.auth.currentUser!.id;
              final imagePath = '$userId/profile';
              final imageUrl = await supabase.storage
                  .from('profiles')
                  .uploadBinary('/$userId/profile', imageBytes);

              // The callback (from the Promise)
              onUpload(imageUrl);
            },
            child: const Text('Upload'))
      ],
    );
  }
}
