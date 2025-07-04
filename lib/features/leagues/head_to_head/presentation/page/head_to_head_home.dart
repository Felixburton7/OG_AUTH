// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:panna_app/core/constants/colors.dart';
// import 'package:panna_app/dependency_injection.dart';
// import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
// import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
// import 'package:panna_app/features/leagues/head_to_head/domain/usecases/fetch_h2h_game_details.dart';
// import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart';
// import 'package:panna_app/features/leagues/head_to_head/presentation/page/head_to_head_create_bet_offer_page.dart';
// import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/head_to_head_my_bets.dart';
// import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/head_to_head_popular.dart';
// import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/head_to_head_settled.dart';
// import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/head_to_head_rules.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class HeadToHeadHome extends StatefulWidget {
//   final LeagueEntity league;

//   const HeadToHeadHome({Key? key, required this.league}) : super(key: key);

//   @override
//   _HeadToHeadHomeState createState() => _HeadToHeadHomeState();
// }

// class _HeadToHeadHomeState extends State<HeadToHeadHome> {
//   final List<String> _filterLabels = ["Popular", "My Bets", "Settled", "Rules"];
//   int _selectedTabIndex = 0; // Default to "My Bets"

//   late final H2hBloc _h2hBloc;

//   @override
//   void initState() {
//     super.initState();
//     // Using dependency injection to obtain the bloc.
//     _h2hBloc = getIt<H2hBloc>()
//       ..add(FetchH2hGameDetails(leagueId: widget.league.leagueId!));
//   }

//   @override
//   void dispose() {
//     _h2hBloc.close();
//     super.dispose();
//   }

//   Future<void> _refreshH2hGameDetails() async {
//     _h2hBloc.add(FetchH2hGameDetails(leagueId: widget.league.leagueId!));
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           // H2H Image (green for light mode, yellow for dark mode)
//           Expanded(
//             child: Text('Head to Head',
//                 style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
//             // child: Image.asset(
//             //   Theme.of(context).brightness == Brightness.light
//             //       ? 'assets/images/games/head-to-head-green.png'
//             //       : 'assets/images/games/head-to-head-yellow.png',
//             //   height: 40,
//             //   alignment: Alignment.centerLeft,
//             //   fit: BoxFit.contain,
//             // ),
//           ),

//           ElevatedButton(
//             onPressed: () {
//               final state = _h2hBloc.state;
//               if (state is H2hLoaded) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CreateBetOfferPage(
//                       h2hGameDetails: state.h2hGameDetails,
//                     ),
//                   ),
//                 ).then((result) {
//                   // If we got a result back with a successful bet, refresh the screen
//                   if (result != null &&
//                       result is Map &&
//                       result['success'] == true) {
//                     _refreshH2hGameDetails();
//                   }
//                 });
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Game details not loaded yet.')),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//             child: const Text(
//               "Create Bet",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterCard(String label, int index) {
//     final bool isSelected = _selectedTabIndex == index;
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.selectionClick();
//         setState(() {
//           _selectedTabIndex = index;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: isSelected ? Colors.black : Colors.grey[300],
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: isSelected ? Colors.white : Colors.grey[800],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: List.generate(
//           _filterLabels.length,
//           (index) => _buildFilterCard(_filterLabels[index], index),
//         ),
//       ),
//     );
//   }

//   /// Builds tab content based on the selected tab.
//   Widget _buildTabContent(H2hGameDetails details) {
//     final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? "";

//     switch (_selectedTabIndex) {
//       case 0: // Popular
//         return const HeadToHeadPopularPage();

//       case 1: // My Bets

//         final myBetOffers = details.betOffers
//             .where((offer) => offer.creatorId == currentUserId)
//             .toList();

//         // Get all challenges (either I challenged someone or someone challenged me)
//         final allChallenges = details.betChallenges ?? [];

//         return HeadToHeadMyBetsPage(
//           myBetOffers: myBetOffers,
//           myBetChallenges: allChallenges,
//           fixtures: details.fixtures,
//           gameDetails: details,
//         );
//       case 2: // Settled tab
//         // For the settled tab, we want to show both settled bet offers and challenges
//         final settledBetOffers = details.betOffers
//             .where((offer) =>
//                 offer.creatorId == currentUserId &&
//                 (offer.status.toLowerCase() == 'settled' ||
//                     offer.status.toLowerCase() == 'cancelled'))
//             .toList();

//         return HeadToHeadSettledPage(
//           settledBetOffers: settledBetOffers,
//           settledChallenges: details.betChallenges,
//           fixtures: details.fixtures,
//           gameDetails: details,
//         );

//       case 3: // Rules tab
//         return const HeadToHeadRulesPage();

//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _buildContent(BuildContext context, H2hGameDetails details) {
//     return SingleChildScrollView(
//       physics: const AlwaysScrollableScrollPhysics(),
//       child: ConstrainedBox(
//         constraints:
//             BoxConstraints(minHeight: MediaQuery.of(context).size.height),
//         child: Column(
//           children: [
//             _buildHeader(),
//             _buildFilterRow(),
//             const Divider(),
//             // The tab content itself (which may be a scrollable list)
//             _buildTabContent(details),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorContent(BuildContext context, String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error, color: Colors.red, size: 64),
//           const SizedBox(height: 16),
//           Text(message, textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<H2hBloc>(
//       create: (_) => _h2hBloc,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Image.asset(
//             Theme.of(context).brightness == Brightness.light
//                 ? 'assets/images/games/H2H-green.png'
//                 : 'assets/images/games/H2H-yellow.png',
//             height: 30,
//             fit: BoxFit.contain,
//           ),
//           centerTitle: true,
//         ),
//         body: RefreshIndicator(
//           onRefresh: _refreshH2hGameDetails,
//           child: BlocBuilder<H2hBloc, H2hState>(
//             builder: (context, state) {
//               if (state is H2hLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is H2hLoaded) {
//                 return _buildContent(context, state.h2hGameDetails);
//               } else if (state is H2hError) {
//                 return _buildErrorContent(context, state.message);
//               } else {
//                 return _buildErrorContent(
//                     context, 'An unexpected error occurred.');
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/fetch_h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/page/head_to_head_create_bet_offer_page.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/head_to_head_my_bets.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/head_to_head_popular.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/head_to_head_settled.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/head_to_head_rules.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HeadToHeadHome extends StatefulWidget {
  final LeagueEntity league;

  const HeadToHeadHome({Key? key, required this.league}) : super(key: key);

  @override
  _HeadToHeadHomeState createState() => _HeadToHeadHomeState();
}

class _HeadToHeadHomeState extends State<HeadToHeadHome> {
  final List<String> _filterLabels = ["Popular", "My Bets", "Settled", "Rules"];
  int _selectedTabIndex = 0; // Default to "Popular"

  late final H2hBloc _h2hBloc;

  @override
  void initState() {
    super.initState();
    // Using dependency injection to obtain the bloc.
    _h2hBloc = getIt<H2hBloc>()
      ..add(FetchH2hGameDetails(leagueId: widget.league.leagueId!));
  }

  @override
  void dispose() {
    _h2hBloc.close();
    super.dispose();
  }

  Future<void> _refreshH2hGameDetails() async {
    _h2hBloc.add(FetchH2hGameDetails(leagueId: widget.league.leagueId!));
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Text('Head to Head',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          ),

          // Create Bet button
          ElevatedButton(
            onPressed: () {
              final state = _h2hBloc.state;
              if (state is H2hLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateBetOfferPage(
                      h2hGameDetails: state.h2hGameDetails,
                    ),
                  ),
                ).then((result) {
                  if (result != null &&
                      result is Map &&
                      result['success'] == true) {
                    _refreshH2hGameDetails();
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Game details not loaded yet.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF053326),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
            child: const Text(
              "Create Bet",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard(String label, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? Colors.black : Colors.grey[300],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          _filterLabels.length,
          (index) => _buildFilterCard(_filterLabels[index], index),
        ),
      ),
    );
  }

  /// Builds tab content based on the selected tab.
  Widget _buildTabContent(H2hGameDetails details) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? "";

    switch (_selectedTabIndex) {
      case 0: // Popular
        return const HeadToHeadPopularPage();

      case 1: // My Bets
        final myBetOffers = details.betOffers
            .where((offer) => offer.creatorId == currentUserId)
            .toList();

        // Get all challenges (either I challenged someone or someone challenged me)
        final allChallenges = details.betChallenges ?? [];

        return HeadToHeadMyBetsPage(
          myBetOffers: myBetOffers,
          myBetChallenges: allChallenges,
          fixtures: details.fixtures,
          gameDetails: details,
        );
      case 2: // Settled tab
        // For the settled tab, we want to show both settled bet offers and challenges
        final settledBetOffers = details.betOffers
            .where((offer) =>
                offer.creatorId == currentUserId &&
                (offer.status.toLowerCase() == 'settled' ||
                    offer.status.toLowerCase() == 'cancelled'))
            .toList();

        return HeadToHeadSettledPage(
          settledBetOffers: settledBetOffers,
          settledChallenges: details.betChallenges,
          fixtures: details.fixtures,
          gameDetails: details,
        );

      case 3: // Rules tab
        return const HeadToHeadRulesPage();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildContent(BuildContext context, H2hGameDetails details) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterRow(),
            const Divider(),
            // The tab content itself (which may be a scrollable list)
            _buildTabContent(details),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<H2hBloc>(
      create: (_) => _h2hBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Head to Head",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshH2hGameDetails,
          child: BlocBuilder<H2hBloc, H2hState>(
            builder: (context, state) {
              if (state is H2hLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is H2hLoaded) {
                return _buildContent(context, state.h2hGameDetails);
              } else if (state is H2hError) {
                return _buildErrorContent(context, state.message);
              } else {
                return _buildErrorContent(
                    context, 'An unexpected error occurred.');
              }
            },
          ),
        ),
      ),
    );
  }
}
