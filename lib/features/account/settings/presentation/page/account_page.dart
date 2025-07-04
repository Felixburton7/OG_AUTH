// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:panna_app/core/constants/spacings.dart';
// import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
// import 'package:panna_app/features/account/settings/presentation/widget/sections/deposit_withdraw_section.dart';
// import 'package:panna_app/features/account/settings/presentation/widget/sections/profile_information_section_snippet.dart';
// import 'package:panna_app/features/account/settings/presentation/widget/sections/help_settings_section.dart';
// import 'package:panna_app/features/auth/presentation/widget/logout_settings_tile.dart';

// class AccountPage extends StatelessWidget {
//   const AccountPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Account',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//       body: BlocBuilder<ProfileCubit, ProfileState>(
//         builder: (context, state) {
//           if (state is ProfileLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is ProfileError) {
//             return const LogoutSettingsTile();
//           } else if (state is ProfileLoaded) {
//             final profile = state.profile;

//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: Spacing.s8),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     DepositWithdrawSection(profile: profile),
//                     ProfileInformationSectionSnippet(profile: profile),
//                     // const SizedBox(height: Spacing.s16),
//                     const SizedBox(height: Spacing.s16),
//                     const HelpSettingsSection(),
//                   ],
//                 ),
//               ),
//             );
//           }
//           return const SizedBox(); // Fallback in case of unexpected state
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/dependency_injection.dart'; // <-- For getIt
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/settings/presentation/widget/sections/deposit_withdraw_section.dart';
import 'package:panna_app/features/account/settings/presentation/widget/sections/help_settings_section.dart';
import 'package:panna_app/features/account/settings/presentation/widget/sections/profile_information_section_snippet.dart';
import 'package:panna_app/features/auth/presentation/widget/logout_settings_tile.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      // Create a fresh ProfileCubit, and fetchProfile() immediately.
      create: (_) => getIt<ProfileCubit>()..fetchProfile(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'My Account',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              // If the profile fails to load, show the logout tile (or any other error UI).
              return const LogoutSettingsTile();
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.s8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DepositWithdrawSection(profile: profile),
                      ProfileInformationSectionSnippet(profile: profile),
                      const SizedBox(height: Spacing.s16),
                      const HelpSettingsSection(),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox(); // Fallback for any unexpected state
          },
        ),
      ),
    );
  }
}
