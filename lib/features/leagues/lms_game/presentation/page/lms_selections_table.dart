import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // If you use go_router
import 'package:panna_app/core/services/firebase_analytics_service.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_players_entity.dart';
import 'package:panna_app/features/leagues/lms_game/presentation/bloc/lms_selections_table/lms_selections_table_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LmsSelectionsTable extends StatefulWidget {
  final LmsGameDetails lmsGameDetails;

  const LmsSelectionsTable({
    Key? key,
    required this.lmsGameDetails,
  }) : super(key: key);

  // Mapping of known team names to crest icons
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
    // Add more teams as needed
  };

  @override
  State<LmsSelectionsTable> createState() => _LmsSelectionsTableState();
}

class _LmsSelectionsTableState extends State<LmsSelectionsTable> {
  int _currentPage = 0;
  late final ScrollController _verticalScrollController;
  late List<LeagueSurvivorRoundsEntity> orderedRounds;

  @override
  void initState() {
    super.initState();
    getIt<FirebaseAnalyticsService>().setCurrentScreen('LMSTablePage');

    _verticalScrollController = ScrollController();
    _setupRounds();
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    super.dispose();
  }

  void _setupRounds() {
    // Sort rounds by roundNumber
    orderedRounds = List.of(widget.lmsGameDetails.leagueSurvivorRounds);
    orderedRounds.sort(
      (a, b) => (a.roundNumber ?? 0).compareTo(b.roundNumber ?? 0),
    );

    // Set _currentPage to the last round if no active round is found
    _currentPage =
        orderedRounds.indexWhere((round) => round.isActiveStatus == true);
    if (_currentPage == -1) {
      _currentPage = orderedRounds.length - 1;
    }
  }

  // Helper function to count picks (selections made) for a given player.
  int _countPicks(String? profileId, LmsSelectionsTableLoaded state) {
    final currentPicks = state.currentSelections
        .where((s) => s.userId == profileId && s.teamName != 'Not Selected')
        .length;
    final historicPicks = state.historicSelections
        .where((s) => s.userId == profileId && s.teamName != 'Not Selected')
        .length;
    return currentPicks + historicPicks;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LmsSelectionsTableCubit()..loadSelections(widget.lmsGameDetails),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'League Table',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: BlocBuilder<LmsSelectionsTableCubit, LmsSelectionsTableState>(
          builder: (context, state) {
            if (state is LmsSelectionsTableLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LmsSelectionsTableLoaded) {
              if (state.lmsPlayers.isEmpty) {
                return const Center(
                  child: Text('No players found in this league.'),
                );
              }

              // 1) Categorise players by buyIn + survivorStatus
              final activePlayers = <LmsPlayersEntity>[];
              final eliminatedPlayers = <LmsPlayersEntity>[];

              for (final player in state.lmsPlayers) {
                if (player.paidBuyIn == true && player.survivorStatus == true) {
                  activePlayers.add(player);
                } else if (player.paidBuyIn == true &&
                    player.survivorStatus == false) {
                  eliminatedPlayers.add(player);
                }
              }

              // NEW: Sort eliminated players by descending picks count
              eliminatedPlayers.sort((a, b) {
                return _countPicks(b.profileId, state)
                    .compareTo(_countPicks(a.profileId, state));
              });

              // 2) Move current user to the top if present
              final currentUserId =
                  Supabase.instance.client.auth.currentUser?.id;
              if (currentUserId != null) {
                final activeIndex = activePlayers.indexWhere(
                  (p) => p.profileId == currentUserId,
                );
                if (activeIndex != -1) {
                  final user = activePlayers.removeAt(activeIndex);
                  activePlayers.insert(0, user);
                }
                final eliminatedIndex = eliminatedPlayers.indexWhere(
                  (p) => p.profileId == currentUserId,
                );
                if (eliminatedIndex != -1) {
                  final user = eliminatedPlayers.removeAt(eliminatedIndex);
                  eliminatedPlayers.insert(0, user);
                }
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<LmsSelectionsTableCubit>()
                      .loadSelections(widget.lmsGameDetails);
                },
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row: pot, survivors, gameweek
                      _buildTopRow(state),
                      const SizedBox(height: 8),

                      // Main Players Table: Active Players
                      _buildPlayersSection(
                        context,
                        state,
                        activePlayers,
                        isEliminated: false,
                      ),

                      // Eliminated Players Table
                      if (eliminatedPlayers.isNotEmpty) ...[
                        Divider(
                          // thickness: 2,
                          color: Colors
                              .transparent, // Red line separating the tables
                        ),
                        _buildPlayersSection(
                          context,
                          state,
                          eliminatedPlayers,
                          isEliminated: true,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            } else if (state is LmsSelectionsTableError) {
              return _buildErrorContent(context, state.message);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  /// Builds the top row: pot total, players remaining, current gameweek
  Widget _buildTopRow(LmsSelectionsTableLoaded state) {
    final round = orderedRounds.isNotEmpty ? orderedRounds[_currentPage] : null;
    final potTotal = '£${(round?.potTotal ?? 0).toStringAsFixed(2)}';
    final currentGW = widget.lmsGameDetails.currentGameweek;
    final survivors = state.playersRemaining;
    final totalPlayers = state.totalPlayers;

    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.88),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeaderColumn('Pot Total', potTotal),
          _buildHeaderColumn(
            'Players Remaining',
            '$survivors/$totalPlayers',
          ),
          _buildHeaderColumn('Gameweek', '$currentGW'),
        ],
      ),
    );
  }

  /// Builds a generic header column used in the top row
  Widget _buildHeaderColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  /// Builds a players section table
  Widget _buildPlayersSection(
    BuildContext context,
    LmsSelectionsTableLoaded state,
    List<LmsPlayersEntity> players, {
    required bool isEliminated,
  }) {
    // Determine gameweeks
    final round = orderedRounds.isNotEmpty ? orderedRounds[_currentPage] : null;
    final gameweekNumbers = _getAllRelevantGameweeks(state, round);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Layout: Left column (players) + horizontally-scrollable GWs
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFixedPlayerColumn(
              context,
              players,
              showHeaders:
                  !isEliminated, // Show headers only for active players
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildGameweekColumns(
                  context,
                  state,
                  players,
                  gameweekNumbers,
                  showHeaders:
                      !isEliminated, // Show headers only for active players
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFixedPlayerColumn(
    BuildContext context,
    List<LmsPlayersEntity> players, {
    required bool showHeaders, // Control visibility of the "Player" header
  }) {
    final rows =
        players.map((player) => _buildPlayerRow(context, player)).toList();

    return SizedBox(
      width: 77, // Adjusted width
      child: DataTable(
        showCheckboxColumn: false,
        columnSpacing: 0.0, // No extra spacing
        headingRowHeight:
            showHeaders ? 32.5 : 0.0, // Remove header for eliminated players
        dataRowHeight: 52.0,
        dividerThickness: 1,
        border: TableBorder(
          bottom: BorderSide(
              color: Colors.grey.shade800, width: 1), // Bottom border
        ),
        columns: showHeaders
            ? [
                const DataColumn(
                  label: SizedBox(
                    width: 77,
                    child: Text(
                      'Player', // Shows only in active table
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ]
            : [
                const DataColumn(
                  label: SizedBox(
                    width: 77,
                  ), // Empty label for eliminated players
                )
              ],
        rows: rows,
      ),
    );
  }

  /// Builds a single player row for the fixed player column
  DataRow _buildPlayerRow(BuildContext context, LmsPlayersEntity player) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isCurrentUser = (player.profileId == currentUserId);
    // Show at most 15 chars of first+last name
    final fullName = _shortName(
      '${player.firstName ?? ''} ${player.lastName ?? ''}'.trim(),
    );

    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: 77, // Adjusted width
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center vertically
              children: [
                // Crest
                Image.asset(
                  LmsSelectionsTable.teamToCrest[player.teamSupported ?? ''] ??
                      'assets/images/default_crest_icon.png',
                  width: 20, // Adjusted size
                  height: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.help_outline,
                    color: Colors.grey,
                    size: 20,
                    semanticLabel: 'No Crest Available',
                  ),
                ),
                const SizedBox(width: 2), // Adjusted spacing
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center vertically
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to start
                    children: [
                      Text(
                        player.username ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: isCurrentUser
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        fullName,
                        style: TextStyle(
                            fontSize: 8,
                            color: Theme.of(context).colorScheme.primary),
                        overflow: TextOverflow.ellipsis,
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
  }

  /// Shortens the player's full name if it exceeds 15 characters
  String _shortName(String name) {
    if (name.length > 15) {
      return '${name.substring(0, 15)}...';
    }
    return name;
  }

  /// Builds the gameweek columns for a table
  Widget _buildGameweekColumns(
    BuildContext context,
    LmsSelectionsTableLoaded state,
    List<LmsPlayersEntity> players,
    List<int> gameweekNumbers, {
    bool showHeaders = true,
  }) {
    return DataTable(
      showCheckboxColumn: false,
      columnSpacing: 0.0, // same style as the members page
      headingRowHeight: showHeaders ? 32.5 : 0.0, // Hide headers if not showing
      dataRowHeight: 52.0,
      border: TableBorder(
        verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
        horizontalInside: BorderSide(color: Colors.grey.shade300, width: 0.5),
        bottom: BorderSide(color: Colors.grey.shade800, width: 1),
      ),
      columns: showHeaders
          ? _buildGameweekColumnsHeaders(gameweekNumbers)
          : List.generate(
              gameweekNumbers.length,
              (_) => const DataColumn(
                label: SizedBox(width: 70), // Empty headers
              ),
            ),
      rows: _buildSelectionRows(
        context,
        state,
        players,
        gameweekNumbers,
      ),
    );
  }

  /// Builds the headers for each gameweek column.
  List<DataColumn> _buildGameweekColumnsHeaders(List<int> gameweekNumbers) {
    return gameweekNumbers.map((gw) {
      return DataColumn(
        label: SizedBox(
          width: 70,
          child: Center(
            child: Text(
              'GW $gw',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  /// Determines all gameweeks relevant to either current or historic selections
  List<int> _getAllRelevantGameweeks(
    LmsSelectionsTableLoaded state,
    LeagueSurvivorRoundsEntity? round,
  ) {
    final gwSet = <int>{};

    // Current selections
    for (final sel in state.currentSelections) {
      gwSet.add(sel.gameWeekNumber);
    }
    // Historic selections
    for (final sel in state.historicSelections) {
      gwSet.add(sel.gameWeekNumber);
    }
    // Current selection
    final current = widget.lmsGameDetails.currentSelection;
    if (current != null) {
      gwSet.add(current.gameWeekNumber);
    }

    // Add two upcoming gameweeks
    final currentGW = widget.lmsGameDetails.currentGameweek;
    if (currentGW != null && currentGW > 0) {
      gwSet.add(currentGW + 1);
      gwSet.add(currentGW + 2);
    }

    final result = gwSet.toList()..sort();
    return result;
  }

  /// Builds each row of gameweek cells
  List<DataRow> _buildSelectionRows(
    BuildContext context,
    LmsSelectionsTableLoaded state,
    List<LmsPlayersEntity> players,
    List<int> gameweekNumbers,
  ) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final currentGW = widget.lmsGameDetails.currentGameweek;
    final isLocked = widget.lmsGameDetails.gameweekLock;

    return players.map((player) {
      final cells = <DataCell>[];

      for (final gw in gameweekNumbers) {
        final isCurrentGW = (gw == currentGW);
        final isUpcomingGW = (gw > currentGW);
        final isCurrentUser = (player.profileId == currentUserId);

        // Find the correct selection
        final selection = _findSelectionFor(
          state: state,
          profileId: player.profileId,
          gameweekNumber: gw,
          roundId: orderedRounds.isNotEmpty
              ? orderedRounds[_currentPage].roundId!
              : '',
          isCurrentGW: isCurrentGW,
          isCurrentUser: isCurrentUser,
          isLocked: isLocked,
        );

        // Determine cell background colour based on result status
        final cellColour = _decideCellColour(
          selection: selection,
          isCurrentGW: isCurrentGW,
          isLocked: isLocked,
          isUpcomingGW: isUpcomingGW,
        );

        // Decide the displayed crest or placeholder
        Widget cellContent;
        if (selection.teamName != 'Not Selected') {
          cellContent = Image.asset(
            LmsSelectionsTable.teamToCrest[selection.teamName ?? ''] ??
                'assets/images/default_logo.png',
            width: 25,
            height: 25,
          );
        } else {
          cellContent = const Text(
            '—',
            style: TextStyle(fontSize: 12),
          );
        }

        cells.add(
          DataCell(
            Container(
              width: 70,
              height: 52,
              color: cellColour,
              alignment: Alignment.center,
              child: cellContent,
            ),
          ),
        );
      }

      return DataRow(cells: cells);
    }).toList();
  }

  /// Finds the selection for a specific (player, gw).
  /// If current week is not locked, we only reveal the current user's pick.
  SelectionsEntity _findSelectionFor({
    required LmsSelectionsTableLoaded state,
    required String? profileId,
    required int gameweekNumber,
    required String roundId,
    required bool isCurrentGW,
    required bool isCurrentUser,
    required bool isLocked,
  }) {
    // If this is the current week
    if (isCurrentGW) {
      // and not locked => show only the current user's pick.
      if (!isLocked && !isCurrentUser) {
        return SelectionsEntity(
          selectionId: '',
          userId: profileId ?? '',
          leagueId: '',
          roundId: roundId,
          teamId: '',
          teamName: 'Not Selected',
          gameWeekId: '',
          gameWeekNumber: gameweekNumber,
          selectionDate: DateTime.now(),
          madeSelectionStatus: false,
          result: null,
        );
      }
      // If locked or isCurrentUser => we can look it up in the "currentSelections" or "historicSelections"
    }

    // 1) Check the currentSelections first
    final fromCurrent = state.currentSelections.firstWhereOrNull(
      (s) => s.userId == profileId && s.gameWeekNumber == gameweekNumber,
    );
    if (fromCurrent != null) return fromCurrent;

    // 2) Otherwise check the "historic" selections
    final fromHistoric = state.historicSelections.firstWhereOrNull(
      (s) => s.userId == profileId && s.gameWeekNumber == gameweekNumber,
    );
    if (fromHistoric != null) return fromHistoric;

    // 3) default => Not selected
    return SelectionsEntity(
      selectionId: '',
      userId: profileId ?? '',
      leagueId: '',
      roundId: roundId,
      teamId: '',
      teamName: 'Not Selected',
      gameWeekId: '',
      gameWeekNumber: gameweekNumber,
      selectionDate: DateTime.now(),
      madeSelectionStatus: false,
      result: null,
    );
  }

  /// Determines cell background color
  Color? _decideCellColour({
    required SelectionsEntity selection,
    required bool isCurrentGW,
    required bool isLocked,
    required bool isUpcomingGW,
  }) {
    // For current gameweek, check the result status:
    if (isCurrentGW) {
      if (selection.result == true) {
        return Colors.green.withOpacity(0.4);
      } else if (selection.result == false) {
        return Colors.red.withOpacity(0.4);
      } else {
        return isLocked ? Colors.blue.withOpacity(0.2) : null;
      }
    } else if (isUpcomingGW) {
      // Future
      return Colors.grey.withOpacity(0.1);
    } else {
      // Past / Historic
      if (selection.result == true) {
        return Colors.green.withOpacity(0.4);
      } else if (selection.result == false) {
        return Colors.red.withOpacity(0.4);
      } else {
        return Colors.transparent;
      }
    }
  }

  /// Builds the error widget
  Widget _buildErrorContent(BuildContext context, String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<LmsSelectionsTableCubit>()
            .loadSelections(widget.lmsGameDetails);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
