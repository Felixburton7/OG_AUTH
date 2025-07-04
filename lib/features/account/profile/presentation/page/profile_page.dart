// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:panna_app/core/constants/font_sizes.dart';
// import 'package:panna_app/core/router/routes.dart';
// import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
// import 'package:panna_app/features/account/profile/presentation/widget/tiles/profile_information_tile.dart';

// class MyProfilePage extends StatelessWidget {
//   const MyProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: [
//             const Expanded(child: SizedBox()), // Empty first column
//             const Expanded(
//               child: Center(
//                 child: Text(
//                   'My Profile',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ), // Centered title in the second column
//             Expanded(
//               child: Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.end, // Aligns content to the right
//                 children: [
//                   BlocBuilder<ProfileCubit, ProfileState>(
//                     builder: (context, state) {
//                       final profile = (state is ProfileLoaded)
//                           ? state.profile
//                           : (state is ProfileAvatarUpdating)
//                               ? state.profile
//                               : null;

//                       final balance =
//                           profile?.accountBalance.toStringAsFixed(2) ?? '0.00';

//                       return Text(
//                         '£$balance',
//                         style: const TextStyle(
//                             fontSize: FontSize.s14,
//                             fontWeight: FontWeight.bold),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.manage_accounts),
//                     onPressed: () async {
//                       final result = await context.push(Routes.account.path);
//                       if (result == true) {
//                         // Profile has been updated, re-fetch the profile
//                         context.read<ProfileCubit>().fetchProfile();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ), // Third column with account balance and icon
//           ],
//         ),
//       ),
//       body: BlocListener<ProfileCubit, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileUpdated) {
//             // You may not need to fetchProfile here if it's already called in the cubit
//           }
//         },
//         child: RefreshIndicator(
//           onRefresh: () async {
//             context.read<ProfileCubit>().fetchProfile();
//           },
//           child: BlocBuilder<ProfileCubit, ProfileState>(
//             builder: (context, state) {
//               if (state is ProfileLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is ProfileError) {
//                 return RefreshIndicator(
//                   onRefresh: () async {
//                     context.read<ProfileCubit>().fetchProfile();
//                   },
//                   child: const SingleChildScrollView(
//                     physics: AlwaysScrollableScrollPhysics(),
//                     child: Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: Text(
//                           'We are having trouble fetching your profile.\nPlease check your internet connection and try again.',
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               } else if (state is ProfileInitial) {
//                 context.read<ProfileCubit>().fetchProfile();
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is ProfileLoaded ||
//                   state is ProfileAvatarUpdating) {
//                 final profile = state is ProfileLoaded
//                     ? state.profile
//                     : (state as ProfileAvatarUpdating).profile;

//                 return SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: Column(
//                     children: [
//                       ProfileInformationTile(profile: profile),
//                     ],
//                   ),
//                 );
//               }
//               return const SizedBox();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/services/widgets/screen_tracker.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/profile/presentation/widget/tiles/profile_information_tile.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the page with ScreenTracker to log the screen view event.
    return ScreenTracker(
      screenName: 'MyProfilePage',
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const Expanded(child: SizedBox()),
              const Expanded(
                child: Center(
                  child: Text(
                    'My Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        final profile = (state is ProfileLoaded)
                            ? state.profile
                            : (state is ProfileAvatarUpdating)
                                ? state.profile
                                : null;
                        final balance =
                            profile?.accountBalance.toStringAsFixed(2) ??
                                '0.00';
                        return Text(
                          '£$balance',
                          style: const TextStyle(
                              fontSize: FontSize.s14,
                              fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.manage_accounts),
                      onPressed: () async {
                        // Log when the manage accounts icon is tapped.
                        getIt<FirebaseAnalyticsService>()
                            .logEvent('manage_accounts_tap');
                        final result = await context.push(Routes.account.path);
                        if (result == true) {
                          context.read<ProfileCubit>().fetchProfile();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              // Optionally log a profile update event.
              getIt<FirebaseAnalyticsService>().logEvent('profile_updated');
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileCubit>().fetchProfile();
            },
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileError) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProfileCubit>().fetchProfile();
                    },
                    child: const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'We are having trouble fetching your profile.\nPlease check your internet connection and try again.',
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (state is ProfileInitial) {
                  context.read<ProfileCubit>().fetchProfile();
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileLoaded ||
                    state is ProfileAvatarUpdating) {
                  final profile = state is ProfileLoaded
                      ? state.profile
                      : (state as ProfileAvatarUpdating).profile;
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        ProfileInformationTile(profile: profile),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
