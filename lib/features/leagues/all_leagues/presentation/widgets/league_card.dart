import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/router/router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/bloc/all_leagues/all_leagues_bloc.dart';

class LeagueCard extends StatelessWidget {
  final LeagueSummary leagueSummary;
  final String defaultImagePath;

  const LeagueCard({
    Key? key,
    required this.leagueSummary,
    required this.defaultImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Non-search view dimensions.
    final double titleFontSize = 18;
    final double membersFontSize = 14;
    final double bioFontSize = 13;
    final double containerHeight = 97;
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
                color: const Color.fromARGB(255, 5, 51, 38).withOpacity(0.4),
                width: 0.4,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            width: 380,
            height: containerHeight,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Avatar, title and member count.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
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
                const SizedBox(height: 5),
                // Bio text added back at the bottom.
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
          // Privacy Indicator.
          Positioned(
            top: 10,
            right: 10,
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
              right: 10,
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



// GREEN LARGE CONCEPT 


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:panna_app/core/constants/font_sizes.dart';
// import 'package:panna_app/core/router/router.dart';
// import 'package:panna_app/core/router/routes.dart';
// import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
// import 'package:panna_app/core/value_objects/leagues/league_details.dart';
// import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
// import 'package:panna_app/features/leagues/all_leagues/presentation/bloc/all_leagues/all_leagues_bloc.dart';

// class LeagueCard extends StatelessWidget {
//   final LeagueSummary leagueSummary;
//   final String defaultImagePath;

//   const LeagueCard({
//     Key? key,
//     required this.leagueSummary,
//     required this.defaultImagePath,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Non-search view dimensions.
//     final double titleFontSize = 25;
//     final double membersFontSize = 14;
//     final double containerHeight = 130;
//     final bool isPrivate = leagueSummary.league.leagueIsPrivate ?? false;

//     // Define the public/active color.
//     const Color publicAndActiveColor = Color(0xFFD0F812);

//     return GestureDetector(
//       onTap: () async {
//         final result = await context.push<bool>(
//           Routes.leagueHome.path,
//           extra: LeagueDetailsArguments(
//             league: leagueSummary.league,
//           ),
//         );
//         if (result == true) {
//           context.read<LeagueBloc>().add(FetchUserLeagues());
//           context.read<ProfileCubit>().fetchProfile();
//         }
//       },
//       child: Stack(
//         children: [
//           Container(
//             margin: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 9),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(
//                   225, 0, 117, 84), // Updated background color
//               border: Border.all(
//                 color: const Color.fromARGB(255, 5, 51, 38),
//                 width: 0.3,
//               ),
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             width: 380,
//             height: containerHeight,
//             padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Top row: (Avatar omitted), title and member count.
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // You can uncomment and use the CircleAvatar if needed.
//                     // CircleAvatar(
//                     //   radius: 25,
//                     //   backgroundColor: const Color.fromARGB(132, 206, 216, 214),
//                     //   child: ClipOval(
//                     //     child: FadeInImage(
//                     //       placeholder: AssetImage(defaultImagePath),
//                     //       image: (leagueSummary.league.leagueAvatarUrl != null &&
//                     //               leagueSummary.league.leagueAvatarUrl!.isNotEmpty)
//                     //           ? NetworkImage(leagueSummary.league.leagueAvatarUrl!)
//                     //           : AssetImage(defaultImagePath) as ImageProvider,
//                     //       fit: BoxFit.cover,
//                     //       width: 38,
//                     //       height: 38,
//                     //       imageErrorBuilder: (context, error, stackTrace) {
//                     //         return Image.asset(
//                     //           defaultImagePath,
//                     //           fit: BoxFit.cover,
//                     //           width: 38,
//                     //           height: 38,
//                     //         );
//                     //       },
//                     //     ),
//                     //   ),
//                     // ),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 3),
//                           Text(
//                             leagueSummary.league.leagueTitle ??
//                                 'Unnamed League',
//                             style: TextStyle(
//                               fontSize: titleFontSize,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white, // Title text in white
//                             ),
//                           ),
//                           Text(
//                             '${leagueSummary.memberCount} members',
//                             style: TextStyle(
//                               fontSize: membersFontSize,
//                               color: Colors.white, // Members text in white
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 // New row of boxes with a white background and primary color text.
//                 Padding(
//                   padding: const EdgeInsets.only(left: 5.0),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         // First box: "Last Man Standing"
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.white, // White background
//                             borderRadius: BorderRadius.circular(7),
//                           ),
//                           child: Text(
//                             'Last Man Standing',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Theme.of(context)
//                                   .primaryColor, // Primary color text
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         // Second box: "GoalScorer Draft"
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.white, // White background
//                             borderRadius: BorderRadius.circular(7),
//                           ),
//                           child: Text(
//                             'GoalScorer Draft',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Theme.of(context)
//                                   .primaryColor, // Primary color text
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         // Third box: "Coming Soon..."
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.white, // White background
//                             borderRadius: BorderRadius.circular(7),
//                           ),
//                           child: Text(
//                             'Coming Soon...',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Theme.of(context)
//                                   .primaryColor, // Primary color text
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Privacy Indicator.
//           Positioned(
//             top: 10,
//             right: 7,
//             child: Container(
//               width: 65,
//               height: 20,
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(8, 249, 250, 246),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     isPrivate ? Icons.lock : Icons.lock_open,
//                     size: 16,
//                     // If the league is public, apply the specified color; otherwise, use white.
//                     color: isPrivate ? Colors.white : publicAndActiveColor,
//                     semanticLabel:
//                         isPrivate ? 'Private League' : 'Public League',
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     isPrivate ? 'Private' : 'Public',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.normal,
//                       // Apply the same color conditionally for the text.
//                       color: isPrivate ? Colors.white : publicAndActiveColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // "In Round" Indicator for active leagues.
//           if (leagueSummary.activeLeague)
//             Positioned(
//               top: 30,
//               right: 7,
//               child: Container(
//                 width: 65,
//                 height: 20,
//                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(8, 249, 250, 246),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.check_circle,
//                       size: 16,
//                       color: publicAndActiveColor, // Active icon color updated
//                       semanticLabel: 'In Round',
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       'Active',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.normal,
//                         color:
//                             publicAndActiveColor, // Active text color updated
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
