import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/profile/presentation/widget/tiles/profile_information_tile.dart';
import 'package:panna_app/features/account/settings/presentation/widget/section_template/settings_section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// features/settings/presentation/widget/profile_settings_section.dart
import 'package:panna_app/dependency_injection.dart';

class ProfileInformationSection extends StatelessWidget {
  const ProfileInformationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..fetchProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileLoaded) {
            final profile = state.profile;

            return SettingsSection(
              title: 'My Profile',
              items: [
                ProfileInformationTile(profile: profile),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
