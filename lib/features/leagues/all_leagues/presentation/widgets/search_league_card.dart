import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/router/router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/bloc/all_leagues/all_leagues_bloc.dart';

class SearchLeagueCard extends StatelessWidget {
  final LeagueSummary leagueSummary;
  final String defaultImagePath;

  const SearchLeagueCard({
    Key? key,
    required this.leagueSummary,
    required this.defaultImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Smaller fonts and container height for search view.
    final double titleFontSize = FontSize.s14 + 2; // e.g. 16 if s14 is 14
    final double membersFontSize = 12;
    final double bioFontSize = 12;
    final double containerHeight = 90;
    final bool isPrivate = leagueSummary.league.leagueIsPrivate ?? false;

    return GestureDetector(
      onTap: () async {
        final result = await context.push<bool>(
          Routes.leagueHome.path,
          extra: LeagueDetailsArguments(
            league: leagueSummary.league,
          ),
        );
        if (result == true) {
          // In a StatelessWidget, we cannot check "mounted" so we simply perform updates.
          context.read<LeagueBloc>().add(FetchUserLeagues());
          context.read<ProfileCubit>().fetchProfile();
        }
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 9),
            decoration: BoxDecoration(
              color: const Color.fromARGB(8, 249, 250, 246),
              border: Border.all(
                color: const Color.fromARGB(255, 5, 51, 38),
                width: 0.3,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            width: 380,
            height: containerHeight,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar, Title, and member count.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color.fromARGB(132, 206, 216, 214),
                      child: ClipOval(
                        child: FadeInImage(
                          placeholder: AssetImage(defaultImagePath),
                          image: (leagueSummary.league.leagueAvatarUrl !=
                                      null &&
                                  leagueSummary
                                      .league.leagueAvatarUrl!.isNotEmpty)
                              ? NetworkImage(
                                  leagueSummary.league.leagueAvatarUrl!)
                              : AssetImage(defaultImagePath) as ImageProvider,
                          fit: BoxFit.cover,
                          width: 38,
                          height: 38,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              defaultImagePath,
                              fit: BoxFit.cover,
                              width: 38,
                              height: 38,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 3),
                          Text(
                            leagueSummary.league.leagueTitle ??
                                'Unnamed League',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${leagueSummary.memberCount} members',
                            style: TextStyle(
                              fontSize: membersFontSize,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    leagueSummary.league.leagueBio ?? 'No league bio available',
                    style: TextStyle(
                      fontSize: bioFontSize,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Privacy Indicator
          Positioned(
            top: 10,
            right: 7,
            child: Container(
              width: 65,
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(8, 249, 250, 246),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isPrivate ? Icons.lock : Icons.lock_open,
                    size: 16,
                    color: const Color.fromARGB(255, 13, 1, 1),
                    semanticLabel:
                        isPrivate ? 'Private League' : 'Public League',
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isPrivate ? 'Private' : 'Public',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // "In Round" Indicator for active leagues.
          if (leagueSummary.activeLeague)
            Positioned(
              top: 30,
              right: 7,
              child: Container(
                width: 65,
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(8, 249, 250, 246),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                      semanticLabel: 'In Round',
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
