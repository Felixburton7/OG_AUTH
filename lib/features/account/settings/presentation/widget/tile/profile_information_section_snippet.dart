import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/settings_tile.dart';

class ProfileInformationSnippetTile extends StatelessWidget {
  final UserProfileEntity profile;

  const ProfileInformationSnippetTile({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      leading: Icons.account_circle,
      title: '${profile.username}',
      subtitle: 'View Profile',
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () async {
        final result =
            await context.push(Routes.editProfile.path, extra: profile);
        if (result == true) {
          // Trigger a profile re-fetch when returning from the Edit Profile page
          context.read<ProfileCubit>().fetchProfile();
        }
      },
    );
  }
}
