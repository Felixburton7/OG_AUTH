import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';

class ProfileInformationTile extends StatelessWidget {
  final UserProfileEntity profile;

  const ProfileInformationTile({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvatarSection(profile: profile),
                const SizedBox(width: 16),
                Expanded(child: _ProfileDetails(profile: profile)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.workspace_premium,
                  size: 20,
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Adapt to the theme
                ),
                const SizedBox(width: 8),
                Text(
                  'Beta Tester',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Adapt to the theme
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              profile.bio?.isNotEmpty == true
                  ? profile.bio!
                  : 'No bio available.',
              style: TextStyle(fontSize: 14, color: textColor),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),
          _ProfileTabs(profile: profile),
        ],
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final UserProfileEntity profile;

  const _AvatarSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          current is ProfileAvatarUpdating || current is ProfileLoaded,
      builder: (context, state) {
        final avatarUrl = state is ProfileLoaded
            ? state.profile.avatarUrl
            : profile.avatarUrl;

        final isValidUrl = avatarUrl != null && avatarUrl.isNotEmpty;
        // Append a dummy query parameter to force the network image to reload.
        final effectiveAvatarUrl = isValidUrl
            ? '$avatarUrl?t=${DateTime.now().millisecondsSinceEpoch}'
            : null;

        return CircleAvatar(
          radius: 50,
          backgroundImage: effectiveAvatarUrl != null
              ? NetworkImage(effectiveAvatarUrl)
              : const AssetImage('assets/images/default_avatar.png')
                  as ImageProvider,
        );
      },
    );
  }
}


class _ProfileDetails extends StatelessWidget {
  final UserProfileEntity profile;

  const _ProfileDetails({required this.profile});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.username ?? 'Unknown User',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const _FollowersFollowingRow(),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () async {
            final result = await context.push(
              Routes.editProfile.path,
              extra: profile,
            );
            if (result == true) {
              context.read<ProfileCubit>().fetchProfile();
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Edit Profile',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FollowersFollowingRow extends StatelessWidget {
  const _FollowersFollowingRow();

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Row(
      children: [
        Text(
          '0 Followers',
          style: TextStyle(fontSize: 16, color: textColor),
        ),
        const SizedBox(width: 16),
        Text(
          '0 Following',
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ],
    );
  }
}

final Map<String, String> teamToCrest = {
  'Arsenal': 'assets/images/arsenal.png',
  'AFC Bournemouth': 'assets/images/bournemouth.png',
  'Brentford': 'assets/images/brentford.png',
  'Brighton & Hove Albion': 'assets/images/brighton.png',
  'Chelsea': 'assets/images/chelsea.png',
  'Everton': 'assets/images/everton_crest.png',
  'Nottingham Forest': 'assets/images/forest.png',
  'Fulham': 'assets/images/fulham.png',
  'Ipswich Town': 'assets/images/ipswich.png',
  'Leicester City': 'assets/images/leicester.png',
  'Liverpool': 'assets/images/liverpool.png',
  'Manchester City': 'assets/images/man_city.png',
  'Manchester United': 'assets/images/man_united.png',
  'Newcastle United': 'assets/images/newcastle.png',
  'Crystal Palace': 'assets/images/palace.png',
  'Southampton': 'assets/images/southampton.png',
  'Tottenham Hotspur': 'assets/images/tottenham.png',
  'Aston Villa': 'assets/images/aston_villa.png',
  'West Ham United': 'assets/images/west_ham.png',
  'Wolverhampton Wanderers': 'assets/images/wolves.png',
};

class _ProfileTabs extends StatelessWidget {
  final UserProfileEntity profile;

  const _ProfileTabs({required this.profile});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Posts'),
            ],
          ),
          SizedBox(
            height: 250,
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                                _buildInfoCard(context, 'Rounds Played', '-'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildInfoCard(context, 'Leagues', '-'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(context, 'LMS Average',
                                '${profile.lmsAverage}'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildCrestCard(
                                context, profile.teamSupported ?? 'N/A'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Center(child: Text('No Posts')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value) {
    final cardColor = Theme.of(context).cardColor;

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: FontSize.s20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrestCard(BuildContext context, String teamName) {
    final teamCrest = teamToCrest[teamName];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              teamCrest ?? 'assets/images/default_avatar.png',
              width: 55,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}
