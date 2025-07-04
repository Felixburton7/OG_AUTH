import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/fixtures_and_standings/data/mapper/game_week_DTO.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/presentation/bloc/view_members_selections_cubit/view_members_selections_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembersSelectionPage extends StatelessWidget {
  final LeagueDetails leagueDetails;

  const MembersSelectionPage({Key? key, required this.leagueDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewMembersSelectionsCubit>(
      create: (_) =>
          ViewMembersSelectionsCubit()..loadSelections(leagueDetails),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Members Selection',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body:
            BlocBuilder<ViewMembersSelectionsCubit, ViewMembersSelectionsState>(
          builder: (context, state) {
            if (state is ViewMembersSelectionsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ViewMembersSelectionsLoaded) {
              return MembersSelectionsTable(leagueDetails: leagueDetails);
            } else if (state is ViewMembersSelectionsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class MembersSelectionsTable extends StatelessWidget {
  final LeagueDetails leagueDetails;

  static const Map<String, String> teamToCrest = {
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

  const MembersSelectionsTable({Key? key, required this.leagueDetails})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final members = leagueDetails.leagueMembers ?? [];

    final activeRound = leagueDetails.leagueSurvivorRounds.firstWhere(
      (round) => round.isActiveStatus == true,
      orElse: () => const LeagueSurvivorRoundsEntity(),
    );

    final sortedMembers = List<LeagueMembersEntity>.from(members)
      ..sort((a, b) => a.survivorStatus == b.survivorStatus
          ? 0
          : (a.survivorStatus == true ? -1 : 1));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: DataTable(
              columnSpacing: 40.0,
              columns: [
                DataColumn(
                    label: Center(
                        child: Text('Username',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer // Dark mode color
                                  : Theme.of(context)
                                      .primaryColor, // Light mode color)),
                            )))),
                DataColumn(
                    label: Center(
                  child: Text('Survivor Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context)
                                .colorScheme
                                .primaryContainer // Dark mode color
                            : Theme.of(context)
                                .primaryColor, // Light mode color)),
                      )),
                )),
                DataColumn(
                  label: Center(
                      child: Text('Previous Pick',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer // Dark mode color
                                    : Theme.of(context)
                                        .primaryColor, // Light mode color)),
                          ))),
                ),
              ],
              rows: sortedMembers.map((member) {
                return DataRow(cells: [
                  _buildUsernameCell(context, member),
                  _buildSurvivorStatusCell(member.survivorStatus),
                  _buildPreviousPickCell(member.previousPickTeamName ?? 'N/A'),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataCell _buildPreviousPickCell(String pickText) {
    return DataCell(
      Center(
        child: pickText != 'N/A'
            ? Image.asset(
                teamToCrest[pickText] ?? 'assets/images/default_crest.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/default_crest.png',
                      width: 30, height: 30, fit: BoxFit.contain);
                },
                semanticLabel: '$pickText Crest',
              )
            : const Icon(Icons.help_outline,
                color: Colors.grey,
                size: 22,
                semanticLabel: 'No Selection Made'),
      ),
    );
  }

  DataCell _buildUsernameCell(
      BuildContext context, LeagueMembersEntity member) {
    return DataCell(
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 13,
              backgroundImage: member.avatarUrl != null &&
                      (member.avatarUrl!.startsWith('http') ||
                          member.avatarUrl!.startsWith('https'))
                  ? NetworkImage(member.avatarUrl!)
                  : const AssetImage('assets/images/placeholder_avatar.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 8),
            Text(
              member.username ?? 'Unknown',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: member.admin == true ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  DataCell _buildSurvivorStatusCell(bool? survivorStatus) {
    return DataCell(
      Center(
        child: Text(
          survivorStatus == true ? 'IN' : 'OUT',
          style: TextStyle(
            color: survivorStatus == true ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}



// class MembersSelectionsTable extends StatelessWidget {
//   final List<LeagueMembersEntity> leagueMembers;
//   final List<SelectionsEntity> currentSelections;
//   final List<SelectionsEntity> historicSelections;
//   final List<SelectionsEntity> upcomingSelections;
//   final int currentGameweek; // New parameter
//   final bool gameweekLock; // New parameter

//   const MembersSelectionsTable({
//     Key? key,
//     required this.leagueMembers,
//     required this.currentSelections,
//     required this.historicSelections,
//     required this.upcomingSelections,
//     required this.currentGameweek, // Initialize new parameter
//     required this.gameweekLock, // Initialize new parameter
//   }) : super(key: key);

//   // Mapping of known team names to crest icons
//   static const Map<String, String> teamToCrest = {
//     'Arsenal': 'assets/images/arsenal.png',
//     'AFC Bournemouth': 'assets/images/bournemouth.png',
//     'Brentford': 'assets/images/brentford.png',
//     'Brighton & Hove Albion': 'assets/images/brighton.png',
//     'Chelsea': 'assets/images/chelsea.png',
//     'Everton': 'assets/images/everton_crest.png',
//     'Nottingham Forest': 'assets/images/forest.png',
//     'Fulham': 'assets/images/fulham.png',
//     'Ipswich Town': 'assets/images/ipswich.png',
//     'Leicester City': 'assets/images/leicester.png',
//     'Liverpool': 'assets/images/liverpool.png',
//     'Manchester City': 'assets/images/man_city.png',
//     'Manchester United': 'assets/images/man_united.png',
//     'Newcastle United': 'assets/images/newcastle.png',
//     'Crystal Palace': 'assets/images/palace.png',
//     'Southampton': 'assets/images/southampton.png',
//     'Tottenham Hotspur': 'assets/images/tottenham.png',
//     'Aston Villa': 'assets/images/aston_villa.png',
//     'West Ham United': 'assets/images/west_ham.png',
//     'Wolverhampton Wanderers': 'assets/images/wolves.png',
//     // Add more teams as needed
//   };

//   @override
//   Widget build(BuildContext context) {
//     // Compute all unique gameweek numbers from selections
//     final gameweekNumbers = _computeGameweeks();

//     // Debugging: Print the gameweek numbers
//     print('Gameweek Numbers: $gameweekNumbers');

//     // Split members into active and inactive
//     final activeMembers = leagueMembers
//         .where((member) =>
//             (member.paidBuyIn ?? false) && (member.survivorStatus ?? false))
//         .toList();
//     final inactiveMembers = leagueMembers
//         .where((member) =>
//             (member.paidBuyIn ?? false) && !(member.survivorStatus ?? false))
//         .toList();

//     // Move current user to the top if present
//     final currentUserId = Supabase.instance.client.auth.currentUser?.id;
//     if (currentUserId != null) {
//       _moveCurrentUserToTop(activeMembers, currentUserId);
//       _moveCurrentUserToTop(inactiveMembers, currentUserId);
//     }

//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Header row: pot, survivors, gameweek
//           _buildTopRow(context),
//           const SizedBox(height: 8),

//           // Active Members Table
//           _buildSectionHeader('Active Members', context),
//           const SizedBox(height: 4),
//           _buildSelectionsTable(context, activeMembers, gameweekNumbers),

//           const SizedBox(height: 16),

//           // Inactive Members Table
//           _buildSectionHeader('Inactive Members', context),
//           const SizedBox(height: 4),
//           _buildSelectionsTable(context, inactiveMembers, gameweekNumbers),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   /// Computes all unique gameweek numbers from current, historic, and upcoming selections
//   List<int> _computeGameweeks() {
//     final gwSet = <int>{};

//     // Current selections
//     for (final sel in currentSelections) {
//       gwSet.add(sel.gameWeekNumber);
//     }

//     // Historic selections
//     for (final sel in historicSelections) {
//       gwSet.add(sel.gameWeekNumber);
//     }

//     // Upcoming selections
//     for (final sel in upcomingSelections) {
//       gwSet.add(sel.gameWeekNumber);
//     }

//     // Optionally, add upcoming gameweeks (e.g., next 2 gameweeks)
//     // Find the current maximum gameweek
//     final maxGW = gwSet.isNotEmpty ? gwSet.reduce((a, b) => a > b ? a : b) : 0;
//     gwSet.add(maxGW + 1);
//     gwSet.add(maxGW + 2);

//     final result = gwSet.toList()..sort();
//     return result;
//   }

//   /// Moves the current user to the top of the list if present
//   void _moveCurrentUserToTop(
//       List<LeagueMembersEntity> members, String currentUserId) {
//     final currentIndex =
//         members.indexWhere((m) => m.profileId == currentUserId);
//     if (currentIndex != -1) {
//       final user = members.removeAt(currentIndex);
//       members.insert(0, user);
//     }
//   }

//   /// Header for each section (Active/Inactive)
//   Widget _buildSectionHeader(String title, BuildContext context) {
//     return Container(
//       width: double.infinity,
//       color: Theme.of(context).primaryColor.withOpacity(0.88),
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   /// Top row: pot total, players remaining, current gameweek
//   Widget _buildTopRow(BuildContext context) {
//     // Update with actual pot total if available
//     final potTotal =
//         '£${leagueMembers.fold<double>(0.0, (sum, member) => sum + (member.accountBalance ?? 0))}';
//     final currentGW = currentGameweek;
//     final survivors =
//         leagueMembers.where((m) => m.survivorStatus ?? false).length;
//     final totalPlayers = leagueMembers.length;

//     return Container(
//       color: Theme.of(context).primaryColor.withOpacity(0.88),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildHeaderColumn('Pot Total', potTotal, context),
//           _buildHeaderColumn(
//               'Players Remaining', '$survivors/$totalPlayers', context),
//           _buildHeaderColumn('Gameweek', '$currentGW', context),
//         ],
//       ),
//     );
//   }

//   /// Builds individual header columns
//   Widget _buildHeaderColumn(String title, String value, BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).canvasColor,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).canvasColor,
//           ),
//         ),
//       ],
//     );
//   }

//   /// Builds each selections table (Active or Inactive)
//   Widget _buildSelectionsTable(BuildContext context,
//       List<LeagueMembersEntity> members, List<int> gameweeks) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildFixedMemberColumn(context, members),
//         Expanded(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: _buildGameweekColumns(context, members, gameweeks),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Fixed left column of members
//   Widget _buildFixedMemberColumn(
//       BuildContext context, List<LeagueMembersEntity> members) {
//     final rows = <DataRow>[];

//     // Add member rows
//     rows.addAll(_buildMemberRowsFixed(context, members));

//     return SizedBox(
//       width: 100, // Adjust width as needed
//       child: DataTable(
//         showCheckboxColumn: false,
//         columnSpacing: 0.0,
//         headingRowHeight: 32.5,
//         dataRowHeight: 52.0,
//         dividerThickness: 1,
//         columns: const [
//           DataColumn(
//             label: SizedBox(
//               width: 100,
//               child: Text(
//                 'Member',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 11,
//                 ),
//               ),
//             ),
//           ),
//         ],
//         rows: rows,
//       ),
//     );
//   }

//   /// Builds member rows for the fixed column
//   List<DataRow> _buildMemberRowsFixed(
//     BuildContext context,
//     List<LeagueMembersEntity> members,
//   ) {
//     final currentUserId = Supabase.instance.client.auth.currentUser?.id;

//     return members.map((member) {
//       final isCurrentUser = (member.profileId == currentUserId);
//       final fullName = _shortName(
//         '${member.firstName ?? ''} ${member.lastName ?? ''}'.trim(),
//       );

//       return DataRow(
//         cells: [
//           DataCell(
//             SizedBox(
//               width: 100,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Team Crest
//                   Image.asset(
//                     teamToCrest[member.teamSupported ?? ''] ??
//                         'assets/images/default_crest_icon.png',
//                     width: 20,
//                     height: 20,
//                     fit: BoxFit.contain,
//                     errorBuilder: (_, __, ___) => const Icon(
//                       Icons.help_outline,
//                       color: Colors.grey,
//                       size: 20,
//                       semanticLabel: 'No Crest Available',
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           member.username ?? 'Unknown',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 10,
//                             color: isCurrentUser
//                                 ? Theme.of(context).colorScheme.secondary
//                                 : Colors.black,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text(
//                           fullName,
//                           style:
//                               const TextStyle(fontSize: 8, color: Colors.grey),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }).toList();
//   }

//   /// Shortens the name if it's too long
//   String _shortName(String name) {
//     if (name.length > 15) {
//       return '${name.substring(0, 15)}...';
//     }
//     return name;
//   }

//   /// Builds the gameweek columns
//   Widget _buildGameweekColumns(BuildContext context,
//       List<LeagueMembersEntity> members, List<int> gameweeks) {
//     return DataTable(
//       showCheckboxColumn: false,
//       columnSpacing: 0.0,
//       headingRowHeight: 32.5,
//       dataRowHeight: 52.0,
//       border: TableBorder(
//         verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
//         horizontalInside: BorderSide(color: Colors.grey.shade300, width: 0.5),
//         bottom: BorderSide(color: Colors.grey.shade800, width: 1),
//       ),
//       columns: _buildGameweekColumnsHeaders(gameweeks),
//       rows: _buildSelectionRows(context, members, gameweeks),
//     );
//   }

//   /// Builds headers for each gameweek column
//   List<DataColumn> _buildGameweekColumnsHeaders(List<int> gameweeks) {
//     return gameweeks.map((gw) {
//       return DataColumn(
//         label: SizedBox(
//           width: 70,
//           child: Center(
//             child: Text(
//               'GW $gw',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }

//   /// Builds each row of gameweek cells
//   List<DataRow> _buildSelectionRows(
//     BuildContext context,
//     List<LeagueMembersEntity> members,
//     List<int> gameweeks,
//   ) {
//     final currentUserId = Supabase.instance.client.auth.currentUser?.id;
//     final isLocked = gameweekLock; // Use the passed gameweekLock

//     return members.map((member) {
//       final cells = <DataCell>[];

//       for (final gw in gameweeks) {
//         final isCurrentGW = gw == currentGameweek;
//         final isUpcomingGW = gw > currentGameweek;
//         final isPastGW = gw < currentGameweek;
//         final isCurrentUser = (member.profileId == currentUserId);

//         // Find the correct selection
//         final selection = _findSelectionFor(
//           profileId: member.profileId,
//           gameweekNumber: gw,
//           isCurrentGW: isCurrentGW,
//           isCurrentUser: isCurrentUser,
//           isLocked: isLocked,
//         );

//         // Determine cell background colour
//         final cellColour = _decideCellColour(
//           selection: selection,
//           isCurrentGW: isCurrentGW,
//           isLocked: isLocked,
//           isUpcomingGW: isUpcomingGW,
//         );

//         // Decide the displayed crest or placeholder
//         Widget cellContent;
//         if (selection.teamName != 'Not Selected') {
//           cellContent = Image.asset(
//             teamToCrest[selection.teamName ?? ''] ??
//                 'assets/images/default_logo.png',
//             width: 25,
//             height: 25,
//           );
//         } else {
//           cellContent = const Text(
//             '—',
//             style: TextStyle(fontSize: 12),
//           );
//         }

//         cells.add(
//           DataCell(
//             Container(
//               width: 70,
//               height: 52,
//               color: cellColour,
//               alignment: Alignment.center,
//               child: cellContent,
//             ),
//           ),
//         );
//       }

//       return DataRow(cells: cells);
//     }).toList();
//   }

//   /// Finds the selection for a specific (member, gw)
//   SelectionsEntity _findSelectionFor({
//     required String? profileId,
//     required int gameweekNumber,
//     required bool isCurrentGW,
//     required bool isCurrentUser,
//     required bool isLocked,
//   }) {
//     if (isCurrentGW) {
//       if (!isLocked && !isCurrentUser) {
//         // Only show own user's selection for the current GW
//         final userSelection = currentSelections.firstWhereOrNull(
//           (s) => s.userId == profileId && s.gameWeekNumber == gameweekNumber,
//         );

//         if (userSelection != null) {
//           return userSelection;
//         } else {
//           return SelectionsEntity(
//             selectionId: '',
//             userId: profileId ?? '',
//             leagueId: '',
//             roundId: '',
//             teamId: '',
//             teamName: 'Not Selected',
//             gameWeekId: '',
//             gameWeekNumber: gameweekNumber,
//             selectionDate: DateTime.now(),
//             madeSelectionStatus: false,
//             result: null,
//           );
//         }
//       }
//     }

//     // Check current selections first
//     final fromCurrent = currentSelections.firstWhereOrNull(
//       (s) => s.userId == profileId && s.gameWeekNumber == gameweekNumber,
//     );
//     if (fromCurrent != null) return fromCurrent;

//     // Check historic selections
//     final fromHistoric = historicSelections.firstWhereOrNull(
//       (s) => s.userId == profileId && s.gameWeekNumber == gameweekNumber,
//     );
//     if (fromHistoric != null) return fromHistoric;

//     // Check upcoming selections
//     final fromUpcoming = upcomingSelections.firstWhereOrNull(
//       (s) => s.userId == profileId && s.gameWeekNumber == gameweekNumber,
//     );
//     if (fromUpcoming != null) return fromUpcoming;

//     // Default: Not selected
//     return SelectionsEntity(
//       selectionId: '',
//       userId: profileId ?? '',
//       leagueId: '',
//       roundId: '',
//       teamId: '',
//       teamName: 'Not Selected',
//       gameWeekId: '',
//       gameWeekNumber: gameweekNumber,
//       selectionDate: DateTime.now(),
//       madeSelectionStatus: false,
//       result: null,
//     );
//   }

//   /// Determines cell background colour
//   Color? _decideCellColour({
//     required SelectionsEntity selection,
//     required bool isCurrentGW,
//     required bool isLocked,
//     required bool isUpcomingGW,
//   }) {
//     // Debugging: Print selection result
//     print(
//         'Selection for GW ${selection.gameWeekNumber}: ${selection.teamName}, Result: ${selection.result}');

//     if (isCurrentGW) {
//       if (isLocked) {
//         return Colors.blue.withOpacity(0.2);
//       }
//       return null;
//     } else if (isUpcomingGW) {
//       return Colors.grey.withOpacity(0.1);
//     } else {
//       // Past GW: Show results
//       if (selection.result == true) {
//         return Colors.green.withOpacity(0.1);
//       } else if (selection.result == false) {
//         return Colors.red.withOpacity(0.1);
//       } else {
//         return Colors.transparent;
//       }
//     }
//   }
// }
