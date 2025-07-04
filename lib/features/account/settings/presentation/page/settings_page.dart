import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/settings/presentation/widget/sections/application_settings_section.dart';
import 'package:panna_app/features/account/settings/presentation/widget/sections/account_settings_section.dart';
import 'package:panna_app/features/account/settings/presentation/widget/sections/info_settings_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..fetchProfile(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else if (state is ProfileLoaded) {
              final profile = state.profile;

              return const Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.s8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ApplicationSettingsSection(),
                      SizedBox(height: Spacing.s16),
                      AccountSettingsSection(),
                      SizedBox(height: Spacing.s16),
                      InfoSettingsSection(),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox(); // Fallback in case of unexpected state
          },
        ),
      ),
    );
  }
}
