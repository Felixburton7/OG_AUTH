import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/page/bet_challenge_slip.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HeadToHeadPopularPage extends StatefulWidget {
  const HeadToHeadPopularPage({Key? key}) : super(key: key);

  @override
  State<HeadToHeadPopularPage> createState() => _HeadToHeadPopularPageState();
}

class _HeadToHeadPopularPageState extends State<HeadToHeadPopularPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateSearchQuery);
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateSearchQuery);
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // Map to get team abbreviations
  Map<String, String> getTeamAbbreviations() {
    return {
      'Arsenal': 'ARS',
      'Aston Villa': 'AVL',
      'AFC Bournemouth': 'BOU',
      'Brentford': 'BRE',
      'Brighton & Hove Albion': 'BHA',
      'Chelsea': 'CHE',
      'Crystal Palace': 'CRY',
      'Everton': 'EVE',
      'Fulham': 'FUL',
      'Ipswich Town': 'IPS',
      'Leicester City': 'LEI',
      'Liverpool': 'LIV',
      'Manchester City': 'MCI',
      'Manchester United': 'MUN',
      'Newcastle United': 'NEW',
      'Nottingham Forest': 'NFO',
      'Southampton': 'SOU',
      'Tottenham Hotspur': 'TOT',
      'West Ham United': 'WHU',
      'Wolverhampton Wanderers': 'WOL',
    };
  }

  // Format creator name as "Lastname, F"
  String formatCreatorName(String firstName, String lastName) {
    if (firstName.isEmpty && lastName.isEmpty) {
      return "Unknown";
    }

    if (firstName.isEmpty) {
      return lastName;
    }

    if (lastName.isEmpty) {
      return firstName;
    }

    return "$lastName, ${firstName[0]}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<H2hBloc, H2hState>(
      builder: (context, state) {
        if (state is H2hLoaded) {
          return _buildPopularBetsList(context, state.h2hGameDetails);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildPopularBetsList(
      BuildContext context, H2hGameDetails gameDetails) {
    // Get current user ID
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';
    final teamAbbreviations = getTeamAbbreviations();

    // Filter out user's own bets and only show open bets
    final otherUsersBets = gameDetails.betOffers
        .where((offer) =>
            offer.creatorId != currentUserId &&
            offer.status.toLowerCase() == 'open')
        .toList();

    // Filter by search query if present
    final filteredBets = _searchQuery.isEmpty
        ? otherUsersBets
        : otherUsersBets.where((offer) {
            final fixture =
                _findFixtureById(gameDetails.fixtures, offer.fixtureId);
            if (fixture == null) return false;

            // Search in team names
            final homeTeam = fixture.homeTeamName?.toLowerCase() ?? '';
            final awayTeam = fixture.awayTeamName?.toLowerCase() ?? '';

            // Search in creator name
            final creatorInfo = _getCreatorInfo(gameDetails, offer.creatorId);
            final creatorName =
                formatCreatorName(creatorInfo.firstName, creatorInfo.lastName)
                    .toLowerCase();

            return homeTeam.contains(_searchQuery) ||
                awayTeam.contains(_searchQuery) ||
                creatorName.contains(_searchQuery);
          }).toList();

    if (filteredBets.isEmpty) {
      return Column(
        children: [
          // Search Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by team or username',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[300],
              ),
            ),
          ),
          _buildEmptyState(),
        ],
      );
    }

    // Group bets by date
    final groupedByDate = _groupBetsByDate(filteredBets, gameDetails.fixtures);

    return CustomScrollView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      slivers: [
        // Search Bar
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by team or username',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[300],
              ),
            ),
          ),
        ),

        // List of matches and bets
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final date = groupedByDate.keys.elementAt(index);
              final fixturesForDay = groupedByDate[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date header
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, bottom: 8.0),
                    child: Text(
                      _formatDateHeader(date),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Fixtures for this day
                  ...fixturesForDay.entries.map((fixtureEntry) {
                    final fixture = fixtureEntry.key;
                    final betsForFixture = fixtureEntry.value;

                    if (betsForFixture.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Fixture header
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0),
                          child:
                              _buildFixtureHeader(fixture, teamAbbreviations),
                        ),

                        // Bet cards for this fixture
                        ...betsForFixture.map((bet) {
                          final creatorInfo =
                              _getCreatorInfo(gameDetails, bet.creatorId);
                          final creatorName = formatCreatorName(
                              creatorInfo.firstName, creatorInfo.lastName);

                          return _buildBetCard(
                            context,
                            bet,
                            fixture,
                            creatorName,
                            teamAbbreviations,
                            gameDetails,
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ],
              );
            },
            childCount: groupedByDate.length,
          ),
        ),
      ],
    );
  }

  Widget _buildFixtureHeader(
      FixtureEntity fixture, Map<String, String> abbrevs) {
    final homeTeam = fixture.homeTeamName ?? 'Home';
    final awayTeam = fixture.awayTeamName ?? 'Away';
    final homeAbbrev =
        abbrevs[homeTeam] ?? homeTeam.substring(0, min(3, homeTeam.length));
    final awayAbbrev =
        abbrevs[awayTeam] ?? awayTeam.substring(0, min(3, awayTeam.length));

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Home team (black bg, white text)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            homeAbbrev,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // VS text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: const Text(
            'VS',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // Away team (white bg, black text)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            awayAbbrev,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // Spacer
        const Spacer(),

        // Challenge bet label - only added in the fixture header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "CHALLENGE BET",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBetCard(
    BuildContext context,
    BetOfferEntity bet,
    FixtureEntity fixture,
    String creatorName,
    Map<String, String> teamAbbrevs,
    H2hGameDetails gameDetails,
  ) {
    // Determine the team name to display
    final homeTeam = fixture.homeTeamName ?? 'Home';
    final awayTeam = fixture.awayTeamName ?? 'Away';
    final isHomeBet = fixture.homeTeamId == bet.teamId;
    final selectedTeam = isHomeBet ? homeTeam : awayTeam;
    final oppositeTeam = isHomeBet ? awayTeam : homeTeam;
    final teamAbbrev = teamAbbrevs[oppositeTeam] ??
        oppositeTeam.substring(0, min(3, oppositeTeam.length));

    // Calculate returns
    final double stake = bet.stakePerChallenge;
    final double multiplier = bet.odds + 1.0;
    final double returns = stake * multiplier;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => BetChallengeSlip(
              betOffer: bet,
              fixture: fixture,
              creatorName: creatorName,
              gameDetails: gameDetails,
            ),
          ).then((result) {
            if (result != null && result['success'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Challenge placed successfully!'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            }
          });
        },
        child: Card(
          elevation: 0.5,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            // side: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Creator name (left side)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(
                    creatorName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Bet details container (right side - 60% of width)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          const Color(0x3090EE90), // Light green with opacity
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Team and bet type
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$teamAbbrev win or draw",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Text(
                            //   "Stake £${stake.toStringAsFixed(0)}",
                            //   style: const TextStyle(
                            //     fontSize: 14,
                            //     color: Colors.green,
                            //   ),
                            // ),
                          ],
                        ),

                        // Right side: Returns and odds
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "x${multiplier.toStringAsFixed(1)}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Return £${returns.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateDay = DateTime(date.year, date.month, date.day);

    if (dateDay == today) {
      return 'Today';
    } else if (dateDay == tomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  Widget _buildEmptyState() {
    final bool isSearching = _searchQuery.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.sports_soccer,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'No bets found for "$_searchQuery"'
                : 'No popular bets available yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching
                ? 'Try a different search term'
                : 'Be the first to create a bet for others',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Group bets by date and then by fixture
  Map<DateTime, Map<FixtureEntity, List<BetOfferEntity>>> _groupBetsByDate(
    List<BetOfferEntity> bets,
    List<FixtureEntity> allFixtures,
  ) {
    // Group by date first
    final Map<DateTime, Map<FixtureEntity, List<BetOfferEntity>>> result = {};

    for (final bet in bets) {
      final fixture = _findFixtureById(allFixtures, bet.fixtureId);
      if (fixture?.startTime != null) {
        final date = DateTime(
          fixture!.startTime!.year,
          fixture.startTime!.month,
          fixture.startTime!.day,
        );

        // Add date if not exists
        if (!result.containsKey(date)) {
          result[date] = {};
        }

        // Add fixture if not exists
        if (!result[date]!.containsKey(fixture)) {
          result[date]![fixture] = [];
        }

        // Add bet to this fixture
        result[date]![fixture]!.add(bet);
      }
    }

    // Sort dates chronologically
    final sortedDates = result.keys.toList()..sort();
    final sortedResult = {for (var date in sortedDates) date: result[date]!};

    return sortedResult;
  }

  FixtureEntity? _findFixtureById(
      List<FixtureEntity> fixtures, String fixtureId) {
    try {
      return fixtures.firstWhere((fixture) => fixture.fixtureId == fixtureId);
    } catch (e) {
      return null;
    }
  }

  // Get creator's name information
  ({String firstName, String lastName}) _getCreatorInfo(
      H2hGameDetails gameDetails, String creatorId) {
    String firstName = '';
    String lastName = '';

    try {
      // Check if this is the current user's profile
      if (gameDetails.profileId == creatorId) {
        firstName = gameDetails.profileFirstName;
        lastName = gameDetails.profileLastName;
        return (firstName: firstName, lastName: lastName);
      }

      // Try to find in league members
      for (final member in gameDetails.leagueMembers) {
        if (member.profileId == creatorId) {
          firstName = member.firstName ?? '';
          lastName = member.lastName ?? '';

          // If no first/last name, try username as fallback
          if (firstName.isEmpty &&
              lastName.isEmpty &&
              member.username != null) {
            final nameParts = member.username!.split(' ');
            if (nameParts.length > 1) {
              firstName = nameParts.first;
              lastName = nameParts.last;
            } else if (nameParts.isNotEmpty) {
              firstName = nameParts.first;
            }
          }

          return (firstName: firstName, lastName: lastName);
        }
      }
    } catch (e) {
      // Ignore errors
    }

    return (firstName: firstName, lastName: lastName);
  }

  int min(int a, int b) => a < b ? a : b;
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:panna_app/core/constants/colors.dart';
// import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
// import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
// import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
// import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart';
// import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/popular_bet_card.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class HeadToHeadPopularPage extends StatefulWidget {
//   const HeadToHeadPopularPage({Key? key}) : super(key: key);

//   @override
//   State<HeadToHeadPopularPage> createState() => _HeadToHeadPopularPageState();
// }

// class _HeadToHeadPopularPageState extends State<HeadToHeadPopularPage> {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//   String _searchQuery = '';
//   bool _isSearchFocused = false;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_updateSearchQuery);
//   }

//   @override
//   void dispose() {
//     _searchFocusNode.dispose();
//     _searchController.removeListener(_updateSearchQuery);
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _updateSearchQuery() {
//     setState(() {
//       _searchQuery = _searchController.text.toLowerCase();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       // Unfocus when tapping outside search
//       onTap: () {
//         if (_searchFocusNode.hasFocus) {
//           _searchFocusNode.unfocus();
//         }
//       },
//       child: BlocBuilder<H2hBloc, H2hState>(
//         builder: (context, state) {
//           if (state is H2hLoaded) {
//             return _buildMainContent(context, state.h2hGameDetails);
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }

//   Widget _buildMainContent(BuildContext context, H2hGameDetails gameDetails) {
//     // Get current user ID
//     final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

//     // Filter out user's own bets and only show open bets
//     final otherUsersBets = gameDetails.betOffers
//         .where((offer) =>
//             offer.creatorId != currentUserId &&
//             offer.status.toLowerCase() == 'open')
//         .toList();

//     // Filter by search query if present
//     final filteredBets = _searchQuery.isEmpty
//         ? otherUsersBets
//         : otherUsersBets.where((offer) {
//             final fixture =
//                 _findFixtureById(gameDetails.fixtures, offer.fixtureId);
//             if (fixture == null) return false;

//             // Search in team names and creator name
//             final homeTeam = fixture.homeTeamName?.toLowerCase() ?? '';
//             final awayTeam = fixture.awayTeamName?.toLowerCase() ?? '';
//             final creatorName =
//                 _findCreatorName(gameDetails, offer.creatorId).toLowerCase();

//             return homeTeam.contains(_searchQuery) ||
//                 awayTeam.contains(_searchQuery) ||
//                 creatorName.contains(_searchQuery);
//           }).toList();

//     // Use a Scaffold-like layout with fixed search at top and scrollable content
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // Search bar - fixed at top
//         _buildSearchBar(),

//         // Main scrollable content
//         Expanded(
//           child: filteredBets.isEmpty
//               ? _buildEmptyState()
//               : _buildBetListing(filteredBets, gameDetails),
//         ),
//       ],
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//       child: GestureDetector(
//         onTap: () {
//           // Set focus on tap
//           FocusScope.of(context).requestFocus(_searchFocusNode);
//         },
//         child: Focus(
//           onFocusChange: (hasFocus) {
//             setState(() {
//               // Update UI when focus changes
//               _isSearchFocused = hasFocus;
//             });
//           },
//           child: TextField(
//             controller: _searchController,
//             focusNode: _searchFocusNode,
//             onChanged: (value) {
//               setState(() {
//                 _searchQuery = value.toLowerCase();
//               });
//             },
//             decoration: InputDecoration(
//               hintText: 'Search teams or users',
//               hintStyle: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 15,
//               ),
//               prefixIcon: Icon(
//                 Icons.search_rounded,
//                 color: _isSearchFocused
//                     ? AppColors.primaryGreen
//                     : Colors.grey[500],
//                 size: 22,
//               ),
//               suffixIcon: _searchController.text.isNotEmpty
//                   ? IconButton(
//                       icon:
//                           Icon(Icons.clear, color: Colors.grey[500], size: 18),
//                       onPressed: () {
//                         _searchController.clear();
//                         setState(() {
//                           _searchQuery = '';
//                         });
//                       },
//                     )
//                   : null,
//               filled: true,
//               fillColor: _isSearchFocused
//                   ? Colors.white
//                   : Colors.grey[200]?.withOpacity(0.7),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: Colors.grey[300]!,
//                   width: 1.0,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: AppColors.primaryGreen.withOpacity(0.8),
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 vertical: 12,
//                 horizontal: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     final bool isSearching = _searchQuery.isNotEmpty;

//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               isSearching ? Icons.search_off : Icons.sports_soccer,
//               size: 64,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               isSearching
//                   ? 'No bets found for "$_searchQuery"'
//                   : 'No popular bets available yet',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               isSearching
//                   ? 'Try a different search term'
//                   : 'Create a bet for others to challenge',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBetListing(
//       List<BetOfferEntity> bets, H2hGameDetails gameDetails) {
//     // Group bets by date first
//     final groupedBets = _groupBetsByDate(bets, gameDetails.fixtures);

//     return ListView.builder(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 20),
//       itemCount: groupedBets.length,
//       itemBuilder: (context, index) {
//         final date = groupedBets.keys.elementAt(index);
//         final betsForDate = groupedBets[date]!;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Date header with highlight style
//             Container(
//               padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
//               child: Row(
//                 children: [
//                   Text(
//                     _formatDateHeader(date),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     height: 5,
//                     width: 30,
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryGreen.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Bets for this date
//             ...betsForDate.map((bet) {
//               final fixture =
//                   _findFixtureById(gameDetails.fixtures, bet.fixtureId);
//               final creatorName = _findCreatorName(gameDetails, bet.creatorId);

//               if (fixture == null) return const SizedBox.shrink();

//               return PopularBetCard(
//                 betOffer: bet,
//                 fixture: fixture,
//                 creatorName: creatorName,
//                 gameDetails: gameDetails,
//               );
//             }).toList(),
//           ],
//         );
//       },
//     );
//   }

//   // Group bets by date
//   Map<DateTime, List<BetOfferEntity>> _groupBetsByDate(
//     List<BetOfferEntity> bets,
//     List<FixtureEntity> fixtures,
//   ) {
//     final Map<DateTime, List<BetOfferEntity>> grouped = {};

//     for (final bet in bets) {
//       final fixture = _findFixtureById(fixtures, bet.fixtureId);
//       if (fixture?.startTime != null) {
//         final date = DateTime(
//           fixture!.startTime!.year,
//           fixture.startTime!.month,
//           fixture.startTime!.day,
//         );

//         if (!grouped.containsKey(date)) {
//           grouped[date] = [];
//         }
//         grouped[date]!.add(bet);
//       }
//     }

//     // Sort dates chronologically
//     final sortedKeys = grouped.keys.toList()..sort();

//     // Create a new map with sorted keys
//     final sortedMap = {for (var key in sortedKeys) key: grouped[key]!};

//     return sortedMap;
//   }

//   String _formatDateHeader(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final tomorrow = today.add(const Duration(days: 1));
//     final dateDay = DateTime(date.year, date.month, date.day);

//     if (dateDay == today) {
//       return 'Today';
//     } else if (dateDay == tomorrow) {
//       return 'Tomorrow';
//     } else {
//       return DateFormat('EEE, MMM d').format(date);
//     }
//   }

//   FixtureEntity? _findFixtureById(
//       List<FixtureEntity> fixtures, String fixtureId) {
//     try {
//       return fixtures.firstWhere((fixture) => fixture.fixtureId == fixtureId);
//     } catch (e) {
//       return null;
//     }
//   }

//   String _findCreatorName(H2hGameDetails gameDetails, String creatorId) {
//     try {
//       // Try to find the member in league members
//       for (final member in gameDetails.leagueMembers) {
//         if (member.profileId == creatorId) {
//           // First try full name
//           final firstName = member.firstName ?? '';
//           final lastName = member.lastName ?? '';
//           if (firstName.isNotEmpty || lastName.isNotEmpty) {
//             return "$firstName $lastName".trim();
//           }

//           // Fall back to username
//           if (member.username != null && member.username!.isNotEmpty) {
//             return member.username!;
//           }
//         }
//       }

//       // If this is the current user
//       if (gameDetails.profileId == creatorId) {
//         final name =
//             "${gameDetails.profileFirstName} ${gameDetails.profileLastName}"
//                 .trim();
//         if (name.isNotEmpty) return name;

//         if (gameDetails.profileUsername.isNotEmpty) {
//           return gameDetails.profileUsername;
//         }
//       }
//     } catch (e) {
//       // Ignore errors
//     }

//     // Fallback
//     return 'User ${creatorId.substring(0, 4)}';
//   }
// }
