import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for haptic feedback
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/network/connection_checker.dart';
import 'package:panna_app/core/router/navigation/nav_drawer_navigator/navigation_drawer.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';
import 'package:panna_app/core/utils/team_name_helper.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/fixtures_and_standings/data/mapper/fixture_DTO.dart';
import 'package:panna_app/features/fixtures_and_standings/data/mapper/game_week_DTO.dart';
import 'package:panna_app/features/fixtures_and_standings/data/mapper/standing_DTO.dart';
import 'package:panna_app/features/fixtures_and_standings/data/supabase_repository/supabase_fixtures_standings_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';

/// Team crest file paths
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

/// Team acronym mapping
final Map<String, String> teamToAcronym = {
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
  'Aston Villa': 'AVL',
  'West Ham United': 'WHU',
  'Wolverhampton Wanderers': 'WOL',
};

/// Enum for the different standings filter options.
enum StandingsFilterOption { wdl, goals, last5 }

@injectable
class LiveScoresStandingsPage extends StatefulWidget {
  const LiveScoresStandingsPage({super.key});

  @override
  _LiveScoresStandingsPageState createState() =>
      _LiveScoresStandingsPageState();
}

class _LiveScoresStandingsPageState extends State<LiveScoresStandingsPage>
    with SingleTickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;

  late TabController _tabController;

  GameWeekDTO? currentGameWeek;
  List<FixtureDTO> currentWeekFixtures = [];
  List<StandingsDTO> standings = [];
  bool isLoading = false;
  bool isPreviousAvailable = true;
  bool isNextAvailable = true;

  /// In-memory cache for team IDs => full names.
  final Map<String, String> _teamNameCache = {};

  /// All fixtures for the season (or loaded gameweeks).
  List<FixtureDTO> allFixtures = [];

  /// Connection Checker instance.
  final ConnectionChecker _connectionChecker =
      GetIt.I<ConnectionChecker>(); // Injected via get_it

  /// Connectivity state.
  bool isNoWifi = false;

  /// Timer for periodic connectivity checks.
  Timer? _connectivityTimer;

  /// State variable to track the selected standings filter.
  StandingsFilterOption _selectedStandingsFilter = StandingsFilterOption.wdl;

  @override
  void initState() {
    super.initState();
    getIt<FirebaseAnalyticsService>()
        .setCurrentScreen('LiveScoresStandingsPage');

    _tabController = TabController(length: 2, vsync: this);

    _checkConnectivity();

    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _checkConnectivity();
      },
    );

    if (!isNoWifi) {
      fetchCurrentGameWeekData();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _connectivityTimer?.cancel();
    super.dispose();
  }

  /// Returns a divider color for the row divider.
  Color _dividerColorForRow(int index) {
    if (index == 3 || index == 4) return const Color(0xFF1C8366);
    if (index == 16) return Colors.red;
    return Colors.grey;
  }

  /// Checks connectivity and refetches data when connection is restored.
  Future<void> _checkConnectivity() async {
    bool connected = await _connectionChecker.isConnected;
    if (!connected && !isNoWifi) {
      if (mounted) {
        setState(() {
          isNoWifi = true;
        });
      }
    } else if (connected && isNoWifi) {
      if (mounted) {
        setState(() {
          isNoWifi = false;
        });
      }
      fetchCurrentGameWeekData();
    }
  }

  /// Fetches current gameweek data and loads all fixtures.
  Future<void> fetchCurrentGameWeekData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final repository = SupabaseFixturesStandingsRepository(supabase);

      currentGameWeek = await repository.fetchCurrentGameWeek();
      if (currentGameWeek == null) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      isPreviousAvailable = currentGameWeek!.gameweekNumber != 1;
      isNextAvailable = await checkNextGameWeekExists();

      final results = await Future.wait([
        repository.fetchStandings(),
        repository.fetchFixturesByGameWeek(currentGameWeek!.gameweekId!),
      ]);
      standings = results[0] as List<StandingsDTO>;
      currentWeekFixtures = results[1] as List<FixtureDTO>;

      final allResults = await repository.fetchAllFixtures();
      allFixtures = allResults as List<FixtureDTO>;

      await _preFetchTeamNames(currentWeekFixtures);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isNoWifi = true;
        });
      }
    }
  }

  Future<void> navigateToPreviousGameWeek() async {
    try {
      if (currentGameWeek!.gameweekNumber! > 1) {
        final repository = SupabaseFixturesStandingsRepository(supabase);
        currentGameWeek = await repository
            .fetchGameWeekByNumber(currentGameWeek!.gameweekNumber! - 1);
        await fetchFixturesForGameWeek(currentGameWeek!.gameweekId!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error navigating to previous game week: ${e.toString()}')),
      );
    }
  }

  Future<void> navigateToNextGameWeek() async {
    try {
      final repository = SupabaseFixturesStandingsRepository(supabase);
      currentGameWeek = await repository
          .fetchGameWeekByNumber(currentGameWeek!.gameweekNumber! + 1);
      if (currentGameWeek != null) {
        await fetchFixturesForGameWeek(currentGameWeek!.gameweekId!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error navigating to next game week: ${e.toString()}')),
      );
    }
  }

  Future<void> fetchFixturesForGameWeek(String gameweekId) async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final repository = SupabaseFixturesStandingsRepository(supabase);
      currentWeekFixtures =
          await repository.fetchFixturesByGameWeek(gameweekId);
      await _preFetchTeamNames(currentWeekFixtures);

      isPreviousAvailable = currentGameWeek?.gameweekNumber != 1;
      isNextAvailable = await checkNextGameWeekExists();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isNoWifi = true;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching fixtures: ${e.toString()}')),
      );
    }
  }

  Future<bool> checkNextGameWeekExists() async {
    try {
      final repository = SupabaseFixturesStandingsRepository(supabase);
      final nextGameWeek = await repository
          .fetchGameWeekByNumber(currentGameWeek!.gameweekNumber! + 1);
      return nextGameWeek != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> _preFetchTeamNames(List<FixtureDTO> fixtures) async {
    final futures = <Future>[];
    for (final fixture in fixtures) {
      final homeTeamId = fixture.homeTeamId ?? '';
      final awayTeamId = fixture.awayTeamId ?? '';
      if (homeTeamId.isNotEmpty && !_teamNameCache.containsKey(homeTeamId)) {
        futures.add(
          SupabaseFixturesStandingsRepository(supabase)
              .fetchTeamNameById(homeTeamId)
              .then((name) => _teamNameCache[homeTeamId] = name)
              .catchError((_) => _teamNameCache[homeTeamId] = 'Unknown Team'),
        );
      }
      if (awayTeamId.isNotEmpty && !_teamNameCache.containsKey(awayTeamId)) {
        futures.add(
          SupabaseFixturesStandingsRepository(supabase)
              .fetchTeamNameById(awayTeamId)
              .then((name) => _teamNameCache[awayTeamId] = name)
              .catchError((_) => _teamNameCache[awayTeamId] = 'Unknown Team'),
        );
      }
    }
    await Future.wait(futures);
  }

  String getFormattedDate(DateTime date) {
    final dayName = DateFormat('EEEE').format(date);
    final day = date.day;
    final month = DateFormat('MMMM').format(date);
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    return '$dayName $month $day$suffix';
  }

  /// Calculates the last five results for a team.
  List<String> getLastFiveResults(String? teamId, String teamName) {
    List<FixtureDTO> teamFixtures;
    if (teamId != null && teamId.isNotEmpty) {
      teamFixtures = allFixtures.where((fixture) {
        return fixture.finishedStatus == true &&
            ((fixture.homeTeamId ?? '') == teamId ||
                (fixture.awayTeamId ?? '') == teamId);
      }).toList();
    } else {
      teamFixtures = allFixtures.where((fixture) {
        return fixture.finishedStatus == true &&
            ((fixture.homeTeamName?.toLowerCase() == teamName.toLowerCase()) ||
                (fixture.awayTeamName?.toLowerCase() ==
                    teamName.toLowerCase()));
      }).toList();
    }
    teamFixtures.sort((a, b) => b.startTime!.compareTo(a.startTime!));
    final lastFive = teamFixtures.take(5).toList();
    return lastFive.map((fixture) {
      if ((fixture.homeTeamId ?? '') == teamId ||
          (teamId == null || teamId.isEmpty) &&
              fixture.homeTeamName?.toLowerCase() == teamName.toLowerCase()) {
        if ((fixture.homeTeamScore ?? 0) > (fixture.awayTeamScore ?? 0))
          return "W";
        if ((fixture.homeTeamScore ?? 0) == (fixture.awayTeamScore ?? 0))
          return "D";
        return "L";
      } else {
        if ((fixture.awayTeamScore ?? 0) > (fixture.homeTeamScore ?? 0))
          return "W";
        if ((fixture.awayTeamScore ?? 0) == (fixture.homeTeamScore ?? 0))
          return "D";
        return "L";
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Live', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Icon(Icons.live_tv, size: 24.0),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refetch Scores',
            onPressed: isLoading ? null : () => fetchCurrentGameWeekData(),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle:
              const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          tabs: [
            Tab(text: 'Live Scores'),
            Tab(text: 'Standings'),
          ],
        ),
      ),
      body: isNoWifi
          ? _buildNoWifiWidget()
          : TabBarView(
              controller: _tabController,
              children: [
                liveScoresTab(),
                standingsTab(),
              ],
            ),
    );
  }

  Widget _buildNoWifiWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your internet connection and try again.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _checkConnectivity(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Live Scores tab.
  Widget liveScoresTab() {
    if (isLoading || currentGameWeek == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<FixtureDTO> sortedFixtures = List.from(currentWeekFixtures);
    sortedFixtures.sort((a, b) {
      final aLive = _isFixtureLive(a);
      final bLive = _isFixtureLive(b);
      if (aLive && !bLive) return -1;
      if (!aLive && bLive) return 1;
      return 0;
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: isPreviousAvailable
                    ? () => navigateToPreviousGameWeek()
                    : null,
              ),
              const SizedBox(width: 20),
              Text(
                'Gameweek ${currentGameWeek?.gameweekNumber ?? ''}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed:
                    isNextAvailable ? () => navigateToNextGameWeek() : null,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedFixtures.length,
            itemBuilder: (context, index) {
              final fixture = sortedFixtures[index];
              final fixtureDate =
                  getFormattedDate(fixture.startTime!.toLocal());
              final isFirstFixtureOfDay = index == 0 ||
                  fixtureDate !=
                      getFormattedDate(
                          sortedFixtures[index - 1].startTime!.toLocal());

              final homeTeamFullName =
                  _teamNameCache[fixture.homeTeamId ?? ''] ?? 'Unknown Team';
              final awayTeamFullName =
                  _teamNameCache[fixture.awayTeamId ?? ''] ?? 'Unknown Team';

              final homeTeamShortName =
                  TeamNameHelper.getShortenedTeamName(homeTeamFullName);
              final awayTeamShortName =
                  TeamNameHelper.getShortenedTeamName(awayTeamFullName);

              final isLive = _isFixtureLive(fixture);
              late final String displayText;
              late final Color displayTextColour;

              if (fixture.finishedStatus ?? false) {
                displayText =
                    '${fixture.homeTeamScore ?? 0} - ${fixture.awayTeamScore ?? 0}';
                displayTextColour = Colors.black;
              } else if (isLive) {
                displayText =
                    '${fixture.homeTeamScore ?? 0} - ${fixture.awayTeamScore ?? 0}';
                displayTextColour = Colors.green;
              } else {
                final hour = fixture.startTime!.toLocal().hour;
                final minute = fixture.startTime!
                    .toLocal()
                    .minute
                    .toString()
                    .padLeft(2, '0');
                displayText = '$hour:$minute';
                displayTextColour = Colors.black54;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isFirstFixtureOfDay)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: Text(
                          fixtureDate,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 7.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    homeTeamShortName,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  teamToCrest[homeTeamFullName] ??
                                      'assets/images/default_logo.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isLive
                                  ? Colors.green.shade50
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              displayText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: displayTextColour,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Image.asset(
                                  teamToCrest[awayTeamFullName] ??
                                      'assets/images/default_logo.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    awayTeamShortName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  /// Determines if a fixture is currently live.
  bool _isFixtureLive(FixtureDTO fixture) {
    if (fixture.startTime == null) return false;
    final now = DateTime.now().toUtc();
    final start = fixture.startTime!.toUtc();
    final end = fixture.endTime?.toUtc();
    if (now.isBefore(start)) return false;
    if (fixture.finishedStatus ?? false) return false;
    if (end != null && now.isAfter(end)) return false;
    return true;
  }

  /// Standings tab built with a custom table.
  Widget standingsTab() {
    if (standings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildStandingsFilterRow(),
          const SizedBox(height: 8),
          _buildStandingsTable(),
        ],
      ),
    );
  }

  Widget _buildStandingsFilterRow() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (mounted) {
                    setState(() {
                      _selectedStandingsFilter = StandingsFilterOption.wdl;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _selectedStandingsFilter ==
                                StandingsFilterOption.wdl
                            ? const Color(0xFF1C8366)
                            : const Color.fromARGB(255, 207, 207, 207)),
                    borderRadius: BorderRadius.circular(20),
                    color: _selectedStandingsFilter == StandingsFilterOption.wdl
                        ? const Color(0xFF1C8366)
                        : Colors.transparent,
                  ),
                  child: Text(
                    'WDL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          _selectedStandingsFilter == StandingsFilterOption.wdl
                              ? Colors.white
                              : const Color.fromARGB(255, 134, 134, 134),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (mounted) {
                    setState(() {
                      _selectedStandingsFilter = StandingsFilterOption.goals;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _selectedStandingsFilter ==
                                StandingsFilterOption.goals
                            ? const Color(0xFF1C8366)
                            : const Color.fromARGB(255, 207, 207, 207)),
                    borderRadius: BorderRadius.circular(20),
                    color:
                        _selectedStandingsFilter == StandingsFilterOption.goals
                            ? const Color(0xFF1C8366)
                            : Colors.transparent,
                  ),
                  child: Text(
                    'Goals',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedStandingsFilter ==
                              StandingsFilterOption.goals
                          ? Colors.white
                          : const Color.fromARGB(255, 134, 134, 134),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (mounted) {
                    setState(() {
                      _selectedStandingsFilter = StandingsFilterOption.last5;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _selectedStandingsFilter ==
                                StandingsFilterOption.last5
                            ? const Color(0xFF1C8366)
                            : const Color.fromARGB(255, 207, 207, 207)),
                    borderRadius: BorderRadius.circular(20),
                    color:
                        _selectedStandingsFilter == StandingsFilterOption.last5
                            ? const Color(0xFF1C8366)
                            : Colors.transparent,
                  ),
                  child: Text(
                    'Last 5',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedStandingsFilter ==
                              StandingsFilterOption.last5
                          ? Colors.white
                          : const Color.fromARGB(255, 134, 134, 134),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandingsTable() {
    List<Widget> rows = [];

    Widget header;
    switch (_selectedStandingsFilter) {
      case StandingsFilterOption.wdl:
        header = _buildHeaderRowWDL();
        break;
      case StandingsFilterOption.goals:
        header = _buildHeaderRowGoals();
        break;
      case StandingsFilterOption.last5:
        header = _buildHeaderRowLast5();
        break;
    }
    rows.add(header);
    rows.add(const Divider(thickness: 1, color: Colors.grey));

    for (int i = 0; i < standings.length; i++) {
      final teamStanding = standings[i];
      Widget dataRow;
      switch (_selectedStandingsFilter) {
        case StandingsFilterOption.wdl:
          dataRow = _buildDataRowWDL(i, teamStanding);
          break;
        case StandingsFilterOption.goals:
          dataRow = _buildDataRowGoals(i, teamStanding);
          break;
        case StandingsFilterOption.last5:
          dataRow = _buildDataRowLast5(i, teamStanding);
          break;
      }
      rows.add(dataRow);
      rows.add(Divider(thickness: 2, color: _dividerColorForRow(i)));
    }
    return Column(children: rows);
  }

  Widget _buildHeaderRowWDL() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text("Team",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Expanded(
              flex: 1,
              child: Text("Pld",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey))),
          Expanded(
              flex: 1,
              child: Text("W",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Expanded(
              flex: 1,
              child: Text("D",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Expanded(
              flex: 1,
              child: Text("L",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Expanded(
              flex: 1,
              child: Text("Pts",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildHeaderRowGoals() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text("Team",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Expanded(
              flex: 1,
              child: Text("Pld",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey))),
          Expanded(
              flex: 1,
              child: Text("GF",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Expanded(
              flex: 1,
              child: Text("GA",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Expanded(
              flex: 1,
              child: Text("GD",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Expanded(
              flex: 1,
              child: Text("Pts",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildHeaderRowLast5() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text("Team",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          for (int i = 0; i < 5; i++) Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }

  Widget _buildDataRowWDL(int index, StandingsDTO teamStanding) {
    final fullTeamName = teamStanding.teamName ?? '';
    final clubAcronym = teamToAcronym[fullTeamName] ?? fullTeamName;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text('${index + 1} '),
                Image.asset(
                  teamToCrest[fullTeamName] ?? 'assets/images/default_logo.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 6),
                Text(clubAcronym,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Text(teamStanding.played?.toString() ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.grey))),
          Expanded(
              flex: 1,
              child: Text(teamStanding.won?.toString() ?? '',
                  style: const TextStyle(fontSize: 14))),
          Expanded(
              flex: 1,
              child: Text(teamStanding.drawn?.toString() ?? '',
                  style: const TextStyle(fontSize: 14))),
          Expanded(
              flex: 1,
              child: Text(teamStanding.lost?.toString() ?? '',
                  style: const TextStyle(fontSize: 14))),
          Expanded(
              flex: 1,
              child: Text(teamStanding.points?.toString() ?? '',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildDataRowGoals(int index, StandingsDTO teamStanding) {
    final fullTeamName = teamStanding.teamName ?? '';
    final clubAcronym = teamToAcronym[fullTeamName] ?? fullTeamName;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text('${index + 1} '),
                Image.asset(
                  teamToCrest[fullTeamName] ?? 'assets/images/default_logo.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 6),
                Text(clubAcronym,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Text(teamStanding.played?.toString() ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.grey))),
          Expanded(
              flex: 1,
              child: Text(teamStanding.goalsFor?.toString() ?? '',
                  style: const TextStyle(fontSize: 14))),
          Expanded(
              flex: 1,
              child: Text(teamStanding.goalsAgainst?.toString() ?? '',
                  style: const TextStyle(fontSize: 14))),
          Expanded(
              flex: 1,
              child: Text(teamStanding.goalDifference?.toString() ?? '',
                  style: const TextStyle(fontSize: 14))),
          Expanded(
              flex: 1,
              child: Text(teamStanding.points?.toString() ?? '',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildDataRowLast5(int index, StandingsDTO teamStanding) {
    final fullTeamName = teamStanding.teamName ?? '';
    final clubAcronym = teamToAcronym[fullTeamName] ?? fullTeamName;
    final lastFive = getLastFiveResults(
        teamStanding.standingsTeamId, teamStanding.teamName ?? '');
    final results = lastFive.length >= 5
        ? lastFive.take(5).toList()
        : (lastFive + List.filled(5 - lastFive.length, ''));
    final reversedResults = results.reversed.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text('${index + 1} '),
                Image.asset(
                  teamToCrest[fullTeamName] ?? 'assets/images/default_logo.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 6),
                Text(clubAcronym,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          for (int i = 0; i < reversedResults.length; i++)
            Expanded(
              flex: 1,
              child: Center(
                child: reversedResults[i].isNotEmpty
                    ? Container(
                        decoration: i == reversedResults.length - 1
                            ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                              )
                            : null,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: reversedResults[i] == 'W'
                              ? Colors.green
                              : reversedResults[i] == 'D'
                                  ? Colors.grey
                                  : reversedResults[i] == 'L'
                                      ? Colors.red
                                      : Colors.transparent,
                          child: Text(reversedResults[i],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}
