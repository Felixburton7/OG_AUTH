import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/router.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/leagues/league_home/presentation/bloc/details/league_details_bloc.dart';
import 'package:panna_app/features/leagues/league_home/presentation/widgets/league_home_guide_tab.dart';

// Tabs replaced with custom filter cards (see _buildTabFilter below)
// Removed: TabBar and DefaultTabController
import 'package:panna_app/features/leagues/league_home/presentation/widgets/league_home_tab.dart';
import 'package:panna_app/features/leagues/league_home/presentation/widgets/league_home_members_tab.dart';
import 'package:panna_app/features/leagues/league_home/presentation/widgets/league_home_settings_tab.dart';

// Header
import 'package:panna_app/features/leagues/league_home/presentation/widgets/league_header.dart';
import 'package:intl/intl.dart'; // For date formatting

import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/utils/string_to_datetime.dart';
import 'package:panna_app/features/chat/domain/entities/messages.dart';
import 'package:panna_app/features/chat/presentation/pages/chat_room_page.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/confirm_join_league_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/pay_buy_in_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/widgets/getGameweekDeadlineFromUpcomingFixtures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Added import for haptic feedback.
import 'package:flutter/services.dart';

/// The main LeagueHome page with three sections: Home, Members, and League Settings.
import 'package:panna_app/features/leagues/league_home/presentation/widgets/league_header.dart';
import 'package:intl/intl.dart'; // For date formatting

import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/utils/string_to_datetime.dart';
import 'package:panna_app/features/chat/domain/entities/messages.dart';
import 'package:panna_app/features/chat/presentation/pages/chat_room_page.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/confirm_join_league_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/pay_buy_in_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/widgets/getGameweekDeadlineFromUpcomingFixtures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The main LeagueHome page with three sections: Home, Members, and League Settings.
class LeagueHome extends StatefulWidget {
  final LeagueDetailsArguments args;

  const LeagueHome({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  State<LeagueHome> createState() => _LeagueHomeState();
}

class _LeagueHomeState extends State<LeagueHome> {
  late final LeagueDetailsBloc _leagueDetailsBloc;
  int _selectedTabIndex = 0; // Custom tab index for filter cards

  @override
  void initState() {
    super.initState();
    _leagueDetailsBloc = getIt<LeagueDetailsBloc>()
      ..add(FetchLeagueDetails(widget.args.league.leagueId!));
  }

  @override
  void dispose() {
    _leagueDetailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _leagueDetailsBloc,
      child: PopScope(
        onPopInvoked: (canPop) {
          if (canPop) {
            Navigator.pop(context, true);
          }
        },
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              _leagueDetailsBloc.add(
                FetchLeagueDetails(widget.args.league.leagueId!),
              );
            },
            child: BlocBuilder<LeagueDetailsBloc, LeagueDetailsState>(
              builder: (context, state) {
                if (state is LeagueDetailsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LeagueDetailsLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1) Header with background image, chat/back icons.
                      // (Make sure to update your LeagueHeader widget to increase the message icon size.)
                      LeagueHeader(
                        leagueDetails: state.leagueDetails,
                        onBackPressed: () => context.pop(true),
                      ),
                      // 2) League info (title, member count & Join Button).
                      _buildLeagueInfo(context, state.leagueDetails),
                      // 3) League bio (if needed).
                      // _buildLeagueBio(context, state.leagueDetails),
                      // 4) Custom Filter Cards replacing TabBar:
                      _buildTabFilter(),
                      // Full width grey divider:
                      const Divider(color: Colors.grey, thickness: 1),
                      // 5) Tab views – shown based on selected filter.
                      Expanded(child: _buildTabContent(state.leagueDetails)),
                    ],
                  );
                } else if (state is LeagueDetailsError) {
                  return _buildErrorContent(context, state.message);
                } else {
                  // Handle other states gracefully.
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Custom filter cards acting as tabs.
  Widget _buildTabFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterCard("Home", 0),
          _buildFilterCard("Members", 1),
          _buildFilterCard("Settings", 2),
          _buildFilterCard("Guide", 3),
        ],
      ),
    );
  }

  /// Returns a clickable filter card.
  Widget _buildFilterCard(String label, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        // Haptic feedback added for filter selection.
        HapticFeedback.selectionClick();
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? const Color(0xFF1C8366)
              : const Color.fromARGB(255, 231, 231, 231),
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

  /// Returns the content for each tab based on _selectedTabIndex.
  Widget _buildTabContent(LeagueDetails leagueDetails) {
    if (_selectedTabIndex == 0) {
      return LeagueHomeHomeTab(leagueDetails: leagueDetails);
    } else if (_selectedTabIndex == 1) {
      return LeagueHomeMembersTab(leagueDetails: leagueDetails);
    } else if (_selectedTabIndex == 2) {
      return LeagueHomeSettingsTab(leagueDetails: leagueDetails);
    } else if (_selectedTabIndex == 3) {
      // Use the new Guide tab here.
      return const LeagueHomeGuideTab();
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Builds an error widget if something goes wrong.
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

  /// Builds the league information section (title, member count, join button).
  Widget _buildLeagueInfo(BuildContext context, LeagueDetails leagueDetails) {
    final theme = Theme.of(context); // Fetch the current user's ID.
    final userId = Supabase.instance.client.auth.currentUser?.id;
    // Check if the user is already a member of the league.
    final isMember = userId != null &&
        leagueDetails.leagueMembers.any((member) => member.profileId == userId);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // The league avatar is removed per request.
          // Title & Members now take full width:
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Stroke (outline) version
                    Text(
                      leagueDetails.league.leagueTitle ?? 'Unnamed League',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 30,
                            // Use a foreground Paint for stroke effect
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1.4 // Adjust for thicker outline
                              ..color = theme.colorScheme.primary,
                          ),
                    ),
                    // Filled version
                    Text(
                      leagueDetails.league.leagueTitle ?? 'Unnamed League',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme
                                .primary, // Or your desired fill color
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Members ${leagueDetails.leagueMembers.length}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 15, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          // Conditionally display the Join League Button.
          if (!isMember) _buildJoinLeagueButton(context, leagueDetails),
        ],
      ),
    );
  }

  /// Builds the league bio section if present.
  Widget _buildLeagueBio(BuildContext context, LeagueDetails leagueDetails) {
    final bio = leagueDetails.league.leagueBio;
    if (bio == null || bio.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        bio,
        style: Theme.of(context).textTheme.bodySmall,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  /// Builds the Join League button.
  Widget _buildJoinLeagueButton(
      BuildContext context, LeagueDetails leagueDetails) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // To allow full height control
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          builder: (context) => FractionallySizedBox(
            heightFactor: 0.35, // Occupy 35% of screen height
            child: ConfirmJoinLeagueBottomSheet(
              leagueDetails: leagueDetails,
              onJoinSuccess: () {
                // Refresh league details after joining.
                _leagueDetailsBloc
                    .add(FetchLeagueDetails(widget.args.league.leagueId!));
              },
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      child: const Text('Join League'),
    );
  }
}
