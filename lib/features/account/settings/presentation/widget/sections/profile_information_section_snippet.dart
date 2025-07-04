import 'package:flutter/material.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/account/settings/presentation/widget/section_template/settings_section.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/profile_information_section_snippet.dart';

class ProfileInformationSectionSnippet extends StatelessWidget {
  final UserProfileEntity profile;
  const ProfileInformationSectionSnippet({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: "Profile",
      items: [
        ProfileInformationSnippetTile(profile: profile),
      ],
    );
  }
}
