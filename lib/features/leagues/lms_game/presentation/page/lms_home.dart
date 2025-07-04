import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pie_chart/pie_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/enums/lms_game/lms_league_button_action.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/app/app_theme.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/pay_buy_in_page.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/presentation/bloc/lms_game/lms_game_bloc.dart';
import 'package:intl/intl.dart';

class LMSHome extends StatefulWidget {
  final LeagueEntity league;

  const LMSHome({Key? key, required this.league}) : super(key: key);

  @override
  State<LMSHome> createState() => _LmsGamePageState();
}

class _LmsGamePageState extends State<LMSHome> {
  late final LmsGameBloc _lmsGameBloc;

  // Mapping team names to crest icons.
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

  // Custom club colors (adjusted for greater distinction and app-friendly contrast)
  static const Map<String, Color> teamColors = {
    'Liverpool': Color(0xFFC8102E),
    'Nottingham Forest': Color(0xFF8B0000),
    'Chelsea': Color(0xFF034694),
    'Newcastle United': Color(0xFF241F20),
    'Brentford': Color.fromARGB(255, 227, 0, 19),
    'Aston Villa': Color(0xFF670E36),
    'Arsenal': Color(0xFFFF4F40),
    'AFC Bournemouth': Color.fromARGB(255, 192, 1, 1),
    'Brighton & Hove Albion': Color(0xFF00A3E0),
    'Everton': Color(0xFF003399),
    'Fulham': Color(0xFF1C1C1C),
    'Ipswich Town': Color(0xFF2A52BE),
    'Leicester City': Color(0xFF002B5C),
    'Manchester City': Color(0xFF6CABDD),
    'Manchester United': Color(0xFFDA291C),
    'Crystal Palace': Color(0xFF1B458F),
    'Southampton': Color.fromARGB(255, 181, 0, 0),
    'Tottenham Hotspur': Color(0xFF132257),
    'West Ham United': Color(0xFF7A263A),
    'Wolverhampton Wanderers': Color(0xFFFF8C00),
  };

  @override
  void initState() {
    super.initState();
    // Log the screen view for LMSHome.
    getIt<FirebaseAnalyticsService>().setCurrentScreen('LMSHome');

    _lmsGameBloc = getIt<LmsGameBloc>()
      ..add(FetchLmsGameDetails(widget.league.leagueId!));
  }

  @override
  void dispose() {
    _lmsGameBloc.close();
    super.dispose();
  }

  Future<void> _refreshLmsGameDetails() async {
    _lmsGameBloc.add(FetchLmsGameDetails(widget.league.leagueId!));
  }

  DateTime _calculateNextDeadline(LmsGameDetails lmsGameDetails) {
    if (lmsGameDetails.currentDeadline != null &&
        lmsGameDetails.currentDeadline!.isAfter(DateTime.now().toUtc())) {
      return lmsGameDetails.currentDeadline!;
    }
    return DateTime.now().toUtc();
  }

  Map<String, double> _getPickDistribution(LmsGameDetails details) {
    List<SelectionsEntity> selections;
    if (details.gameweekLock) {
      selections = details.currentSelections
          .where((s) => s.gameWeekNumber == details.currentGameweek)
          .toList();
    } else {
      final previousGameweek = details.currentGameweek > 1
          ? details.currentGameweek - 1
          : details.currentGameweek;
      selections = details.historicSelections
          .where((s) => s.gameWeekNumber == previousGameweek)
          .toList();
    }
    final Map<String, double> distribution = {};
    for (var sel in selections) {
      distribution[sel.teamName] = (distribution[sel.teamName] ?? 0) + 1;
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    final String logoPath = Theme.of(context).brightness == Brightness.light
        ? AppThemeAssets.lmsAbrevLight
        : AppThemeAssets.lmsAbrevDark;

    return BlocProvider.value(
      value: _lmsGameBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            logoPath,
            height: 40,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(true),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshLmsGameDetails,
          child: BlocBuilder<LmsGameBloc, LmsGameState>(
            builder: (context, state) {
              if (state is LmsGameLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LmsGameLoaded) {
                return _buildContent(context, state.lmsGameDetails);
              } else if (state is LmsGameError) {
                return _buildErrorContent(context, state.message);
              } else {
                return _buildErrorContent(
                    context, 'An unexpected error has occurred.');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LmsGameDetails details) {
    final activeRound = details.leagueSurvivorRounds.firstWhere(
      (round) => round.isActiveStatus == true,
      orElse: () => const LeagueSurvivorRoundsEntity(),
    );
    final hasActiveRound = activeRound.isActiveStatus;
    final survivorsRemaining =
        details.lmsPlayers.where((p) => p.survivorStatus == true).length;
    final totalMembers = details.lmsPlayers.length;
    final potTotal = activeRound.potTotal ?? 0.0;
    final gameweekDeadline = _calculateNextDeadline(details);
    final currentGW = details.currentGameweek;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final diff = gameweekDeadline.difference(DateTime.now()).abs();
    final days = twoDigits(diff.inDays);
    final hours = twoDigits(diff.inHours.remainder(24));
    final minutes = twoDigits(diff.inMinutes.remainder(60));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // POT TOTAL circle.
          Center(
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(65, 94, 128, 107),
                  width: 6,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'POT TOTAL',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '£${potTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (hasActiveRound == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          border: Border.all(
                            color: AppColors.pannaYellow,
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(fontSize: 12, color: Colors.green),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionInfoCard(details, activeRound),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '@${details.league.leagueTitle}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildActionButton(context, details),
            ],
          ),
          _buildSelectionRowWithIcon(
            icon: Icons.swap_vert_circle_rounded,
            label: 'Team Selection:',
            selection: details.currentSelection,
          ),
          _buildStatRowWithIcon(
            icon: Icons.people,
            label: 'Players Remaining:',
            value: '$survivorsRemaining/$totalMembers',
          ),
          const SizedBox(height: 16),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 117, 84),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "GW $currentGW SELECTION DEADLINE",
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCountdownSegment(context, days, 'DAYS'),
                    Transform.translate(
                      offset: const Offset(0, -13),
                      child: const Text(
                        ' : ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildCountdownSegment(context, hours, 'HOURS'),
                    Transform.translate(
                      offset: const Offset(0, -13),
                      child: const Text(
                        ' : ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildCountdownSegment(context, minutes, 'MINS'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await context.push<bool>(
                        Routes.lmsCurrentMatchesPage.path,
                        extra: details,
                      );
                      if (result == true) {
                        _lmsGameBloc
                            .add(FetchLmsGameDetails(widget.league.leagueId!));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Make Selection',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildPrimaryActionCard(
                  context,
                  title: 'League Tables',
                  icon: Icons.table_chart,
                  onTap: () {
                    context.push(Routes.lmsSelectionsTable.path,
                        extra: details);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPrimaryActionCard(
                  context,
                  title: 'Game Rules',
                  icon: Icons.rule,
                  onTap: () {
                    context.push(Routes.LmsRulesPage.path);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: _buildSecondaryActionCard(
              context,
              title: 'League Info',
              onTap: () {
                context.push(Routes.roundsPage.path, extra: details);
              },
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: Theme.of(context).dividerColor, thickness: 1),
          const SizedBox(height: 16),
          // STATISTICS SECTION
          Text(
            'Weekly Insights',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Commented out the old Pie Chart and Histogram widgets
          // _buildPieChartWidget(details),
          // _buildHistogramWidget(details),
          // New Weekly Insights widget:
          _buildWeeklyInsightsWidget(details),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWeeklyInsightsWidget(LmsGameDetails details) {
    final distribution = _getPickDistribution(details);
    if (distribution.isEmpty) {
      return Center(
        child: Text(
          'No selections available for this gameweek.',
          style: TextStyle(fontSize: 14),
        ),
      );
    }
    // Team abbreviation mapping.
    const Map<String, String> teamAbbr = {
      'Arsenal': 'ARS',
      'AFC Bournemouth': 'BOU',
      'Brentford': 'BRE',
      'Brighton & Hove Albion': 'BHA',
      'Chelsea': 'CHE',
      'Everton': 'EVE',
      'Nottingham Forest': 'NFO',
      'Fulham': 'FUL',
      'Ipswich Town': 'IPS',
      'Leicester City': 'LEI',
      'Liverpool': 'LIV',
      'Manchester City': 'MCI',
      'Manchester United': 'MUN',
      'Newcastle United': 'NEW',
      'Crystal Palace': 'CRY',
      'Southampton': 'SOU',
      'Tottenham Hotspur': 'TOT',
      'Aston Villa': 'AVI',
      'West Ham United': 'WHU',
      'Wolverhampton Wanderers': 'WOL',
    };

    // Sort the entries in descending order of picks.
    final sortedEntries = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = distribution.values.fold(0.0, (sum, val) => sum + val);

    // Determine the top team.
    final topTeamKey = sortedEntries.first.key;
    final topTeamAbbr =
        teamAbbr[topTeamKey] ?? topTeamKey.substring(0, 3).toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top team info at the top right.
        Align(
          alignment: Alignment.center,
          child: Text.rich(
            TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
              children: [
                const TextSpan(
                  text: "The top team picked this week was ",
                ),
                TextSpan(
                  text: topTeamKey,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Weekly insights list.
        Column(
          children: sortedEntries.map((entry) {
            final abbr =
                teamAbbr[entry.key] ?? entry.key.substring(0, 3).toUpperCase();
            final percentage = entry.value / total;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  // Column 1: Club abbreviation with reduced left padding.
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: Text(
                        abbr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  // Column 2: Club crest, centered.
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Image.asset(
                        teamToCrest[entry.key] ??
                            'assets/images/default_logo.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  // Column 3: Number of picks.
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        entry.value.toInt().toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Column 4: Horizontal bar representing percentage (longer).
                  Expanded(
                    flex: 6,
                    child: Stack(
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: percentage,
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: teamColors[entry.key] ?? Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionInfoCard(
      LmsGameDetails details, LeagueSurvivorRoundsEntity activeRound) {
    switch (details.lmsButtonAction) {
      case LmsLeagueButtonAction.payBuyIn:
        return _buildInfoCard(
          message:
              "Round is available to join and starts this week. Click 'Pay Buy-In' to join and make selection.",
          color: Colors.green.withOpacity(0.2),
          icon: Icons.payment,
        );
      case LmsLeagueButtonAction.outOfLeague:
        return _buildInfoCard(
          message:
              "You are out of the league. Please wait for the next round to pay the buy-in and join.",
          color: Colors.red.withOpacity(0.1),
          icon: Icons.close,
        );
      case LmsLeagueButtonAction.selectionLocked:
        return _buildInfoCard(
          message: "Selections locked as the games are in progress",
          color: Colors.red.withOpacity(0.1),
          icon: Icons.lock,
        );
      case LmsLeagueButtonAction.roundInSession:
        return _buildInfoCard(
          message:
              "This game is not available to join. Current round in progress or recently concluded.",
          color: Colors.red.withOpacity(0.1),
          icon: Icons.lock,
        );
      case LmsLeagueButtonAction.showCurrentSelection:
        return _buildInfoCard(
          message: "You have made a selection for the current gameweek.",
          color: Colors.blue.withOpacity(0.2),
          icon: Icons.check_circle,
        );
      case LmsLeagueButtonAction.showNoSelectionMade:
        return _buildInfoCard(
          message: "No selection made for the current gameweek.",
          color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.1),
          icon: Icons.help_outline,
        );
      case LmsLeagueButtonAction.none:
        return _buildInfoCard(
          message:
              "Click 'Join league' button to see if you you are eligible to pay-buy in and play this game.",
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          icon: Icons.arrow_back_ios,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInfoCard(
      {required String message, required Color color, IconData? icon}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.black),
            const SizedBox(width: 8),
          ],
          Expanded(
              child: Text(message,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14))),
        ],
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

  Widget _buildActionButton(BuildContext context, LmsGameDetails details) {
    switch (details.lmsButtonAction) {
      case LmsLeagueButtonAction.payBuyIn:
        return ElevatedButton.icon(
          onPressed: () async {
            final result = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              builder: (ctx) {
                return PayBuyInBottomSheet(lmsGameDetails: details);
              },
            );
            if (result == true) {
              _refreshLmsGameDetails();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'You have successfully paid the buy-in and joined the league'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (result == false) {
              _refreshLmsGameDetails();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Funds deposited successfully. You can now pay the buy-in.'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          },
          icon: const Icon(Icons.payment),
          label: const Text('Pay Buy-In'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        );
      case LmsLeagueButtonAction.showCurrentSelection:
        final teamName = details.currentSelection?.teamName;
        if (teamName != null) {
          return const Text('Selection Made',
              style: TextStyle(fontSize: 14, color: Colors.green));
        } else {
          return Text('No Selection?',
              style: TextStyle(fontSize: 14, color: Colors.blue[800]));
        }
      case LmsLeagueButtonAction.showNoSelectionMade:
        return const Text('No Selection Made',
            style: TextStyle(fontSize: 14, color: Colors.red));
      case LmsLeagueButtonAction.outOfLeague:
        return ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.close, color: Colors.red),
          label: const Text('OUT'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        );
      case LmsLeagueButtonAction.selectionLocked:
        return const Text('Selections Locked',
            style: TextStyle(fontSize: 14, color: Colors.orange));
      default:
        return const SizedBox.shrink();
    }
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
                        fontWeight: FontWeight.bold))),
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


mixin HomeUserMixin
    on
        State<HomeTabView>,
        SnackbarMessageMixin,
        // BottomSheetMixin,
        // MethodHelperMixin,
        BaseState<HomeTabView> {
  Future<void> checkSurvey() async {}

  Future<void> checkUserVerify() async {
    await Future.microtask(() {});
    final user = userContext.apiContext;
    if (user == null) return;
    if (user.emailVerified ?? false) return;
    final remainDay = user.verifiedDayLength;

