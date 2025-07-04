///// PAGE NOT IN USE

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/utils/date_helper.dart';
import 'package:panna_app/core/utils/team_name_helper.dart'; // Import TeamNameHelper class
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/pay_buy_in_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/bloc/current_selections/current_selections_bloc.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';

class CurrentMatchesPage extends StatefulWidget {
  final LeagueDetails leagueDetails;

  const CurrentMatchesPage({
    Key? key,
    required this.leagueDetails,
  }) : super(key: key);

  @override
  _CurrentMatchesPageState createState() => _CurrentMatchesPageState();
}

class _CurrentMatchesPageState extends State<CurrentMatchesPage> {
  late CurrentSelectionsBloc _bloc;

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

  @override
  void initState() {
    super.initState();
    getIt<FirebaseAnalyticsService>().setCurrentScreen('MakeSelectionPage');

    _bloc = getIt<CurrentSelectionsBloc>()
      ..add(LoadCurrentFixturesEvent(leagueDetails: widget.leagueDetails));
  }

  @override
  void dispose() {
    _bloc.close(); // Close the Bloc to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context, true); // Pass true to indicate an update occurred
        return false;
      },
      child: BlocProvider<CurrentSelectionsBloc>.value(
        value: _bloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Make Selection',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0,
          ),
          body: BlocListener<CurrentSelectionsBloc, CurrentSelectionsState>(
            listener: (context, state) {
              if (state is CurrentSelectionsError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              } else if (state is CurrentSelectionsLoaded) {
                if (state.errorMessage != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }
                if (state.successMessage != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showConfirmationDialog(context, state.selectedTeamName);
                  });
                }
              }
            },
            child: BlocBuilder<CurrentSelectionsBloc, CurrentSelectionsState>(
              builder: (context, state) {
                if (state is CurrentSelectionsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CurrentSelectionsLoaded) {
                  final activeWeek = state.leagueDetails.currentGameweek != null
                      ? 'Week ${state.leagueDetails.currentGameweek}'
                      : 'Round not started';

                  // Determine if the current gameweek is locked
                  final isGameweekLocked = state.leagueDetails.gameweekLock;

                  // Group fixtures by formatted date
                  final Map<String, List<FixtureEntity>> groupedFixtures = {};
                  for (var fixture in state.currentFixtures) {
                    if (fixture.startTime != null) {
                      final date = DateTime(
                        fixture.startTime!.year,
                        fixture.startTime!.month,
                        fixture.startTime!.day,
                      );
                      final formattedDate = DateHelper.getFormattedDate(date);
                      if (groupedFixtures.containsKey(formattedDate)) {
                        groupedFixtures[formattedDate]!.add(fixture);
                      } else {
                        groupedFixtures[formattedDate] = [fixture];
                      }
                    }
                  }

                  // Sort the grouped entries by date
                  final groupedEntries = groupedFixtures.entries.toList()
                    ..sort((a, b) {
                      final dateA = DateFormat('EEEE MMMM d').parse(a.key);
                      final dateB = DateFormat('EEEE MMMM d').parse(b.key);
                      return dateA.compareTo(dateB);
                    });

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            // Display the "Pay buy-in" message if needed
                            if (!state.leagueDetails.hasPaidBuyIn)
                              GestureDetector(
                                onTap: () {
                                  // Pop this page and return true to indicate the buy-in action
                                  Navigator.of(context).pop(true);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Pay buy-in to join round',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            // Display the "Gameweek Locked" message if needed
                            if (isGameweekLocked)
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                width: double.infinity,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Center(
                                  child: Text(
                                    'This gameweek is currently locked.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            const Divider(),
                            Center(
                              child: Text(
                                activeWeek,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const Divider(),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 100),
                                itemCount: groupedEntries.length,
                                itemBuilder: (context, groupIndex) {
                                  final group = groupedEntries[groupIndex];
                                  final dateHeader = group.key;
                                  final fixtures = group.value;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Center(
                                        child: Text(
                                          dateHeader,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Column(
                                        children: fixtures.map((fixture) {
                                          final homeTeamFull =
                                              fixture.homeTeamName!;
                                          final awayTeamFull =
                                              fixture.awayTeamName!;
                                          final homeTeamShort = TeamNameHelper
                                              .getShortenedTeamName(
                                                  homeTeamFull);
                                          final awayTeamShort = TeamNameHelper
                                              .getShortenedTeamName(
                                                  awayTeamFull);
                                          final isHomeTeamAvailable =
                                              state.survivorStatus &&
                                                  state.availableTeamNames
                                                      .contains(homeTeamFull) &&
                                                  !isGameweekLocked;
                                          final isAwayTeamAvailable =
                                              state.survivorStatus &&
                                                  state.availableTeamNames
                                                      .contains(awayTeamFull) &&
                                                  !isGameweekLocked;
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: _buildNewTeamCard(
                                                      context,
                                                      teamName: homeTeamShort,
                                                      fullTeamName:
                                                          homeTeamFull,
                                                      isAvailable:
                                                          isHomeTeamAvailable,
                                                      isSelected: state
                                                              .selectedTeamName ==
                                                          homeTeamFull,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Text(
                                                    fixture.startTime != null
                                                        ? DateFormat.Hm()
                                                            .format(fixture
                                                                .startTime!)
                                                        : 'TBD',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    flex: 2,
                                                    child: _buildNewTeamCard(
                                                      context,
                                                      teamName: awayTeamShort,
                                                      fullTeamName:
                                                          awayTeamFull,
                                                      isAvailable:
                                                          isAwayTeamAvailable,
                                                      isSelected: state
                                                              .selectedTeamName ==
                                                          awayTeamFull,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              if (fixture != fixtures.last)
                                                Divider(
                                                  color: Theme.of(context)
                                                      .dividerColor,
                                                ),
                                              const SizedBox(height: 10),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.hasSelectionChanged &&
                          state.survivorStatus &&
                          !isGameweekLocked)
                        Positioned(
                          bottom: 20,
                          left: 16,
                          right: 16,
                          child: Center(
                            child: _buildConfirmButton(state),
                          ),
                        ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String? selectedTeamName) {
    // Log analytics event for successful selection.
    getIt<FirebaseAnalyticsService>()
        .logEvent('selection_success', parameters: {
      'selected_team': selectedTeamName,
      'league_id': widget.leagueDetails.league.leagueId,
      'league_title': widget.leagueDetails.league.leagueTitle,
      'username': widget.leagueDetails.userProfile.username,
      'first_name': widget.leagueDetails.userProfile.firstName,
      'last_name': widget.leagueDetails.userProfile.lastName,
    });
    final teamCrest =
        teamToCrest[selectedTeamName] ?? 'assets/images/default_crest.png';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                teamCrest,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
                semanticLabel: '$selectedTeamName Crest',
              ),
              const SizedBox(height: 16),
              Text(
                'You successfully selected $selectedTeamName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewTeamCard(
    BuildContext context, {
    required String teamName,
    required String fullTeamName,
    required bool isAvailable,
    required bool isSelected,
  }) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(8),
      child: ElevatedButton(
        onPressed: isAvailable
            ? () {
                _bloc.add(SelectTeamEvent(teamName: fullTeamName));
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isAvailable
              ? (isSelected
                  ? Theme.of(context).primaryColor
                  : (isDarkMode
                      ? Theme.of(context).indicatorColor
                      : Colors.white))
              : AppColors.grey400,
          foregroundColor: isAvailable
              ? (isSelected
                  ? Colors.white
                  : (isDarkMode
                      ? Theme.of(context).primaryColorDark
                      : Theme.of(context).primaryColor))
              : AppColors.grey500,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              teamToCrest[fullTeamName] ?? 'assets/images/default_crest.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
              semanticLabel: '$fullTeamName Crest',
            ),
            const SizedBox(height: 4),
            Text(
              teamName,
              style: TextStyle(
                color: isAvailable
                    ? (isSelected
                        ? Colors.white
                        : Theme.of(context).primaryColor)
                    : AppColors.grey500,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(CurrentSelectionsLoaded state) {
    return ElevatedButton(
      onPressed: () {
        if (state.selectedTeamName != null) {
          _bloc.add(
            ConfirmTeamSelectionEvent(
              leagueId: widget.leagueDetails.league.leagueId!,
              teamName: state.selectedTeamName!,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColor
            : Theme.of(context).indicatorColor,
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2.0,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Confirm Selection',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }

  Widget _buildStatRowWithIcon(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSelectionRowWithIcon(
      {required IconData icon,
      required String label,
      required SelectionsEntity? selection}) {
    final teamName = selection?.teamName;
    Widget selectionWidget;
    if (teamName != null && teamToCrest.containsKey(teamName)) {
      selectionWidget = Image.asset(teamToCrest[teamName]!,
          width: 40, height: 40, fit: BoxFit.contain);
    } else if (teamName != null) {
      selectionWidget = Image.asset('assets/images/default_blue_gradient.png',
          width: 40, height: 40, fit: BoxFit.contain);
    } else {
      selectionWidget = Icon(Icons.help_outline,
          size: 32, color: Theme.of(context).colorScheme.primary);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          selectionWidget,
        ],
      ),
    );
  }

  Widget _buildCountdownSegment(
      BuildContext context, String number, String label) {
    return Column(
      children: [
        Text(number,
            style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }

  Widget _buildPrimaryActionCard(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.pannaGreen,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActionCard(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Center(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }
}
