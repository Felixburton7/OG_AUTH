import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_players_entity.dart';

class RoundsPage extends StatefulWidget {
  final LmsGameDetails lmsGameDetails;

  const RoundsPage({Key? key, required this.lmsGameDetails}) : super(key: key);

  @override
  _RoundsPageState createState() => _RoundsPageState();
}

class _RoundsPageState extends State<RoundsPage> {
  int selectedRoundNumber = 1;

  @override
  void initState() {
    super.initState();
    final activeRound = widget.lmsGameDetails.leagueSurvivorRounds.firstWhere(
      (round) => round.isActiveStatus == true,
      orElse: () => widget.lmsGameDetails.leagueSurvivorRounds.first,
    );
    selectedRoundNumber = activeRound.roundNumber ?? 1;
  }

  /// Formats a given [date] to a nice format, e.g. "Thursday 1st, JAN 2025"
  String _formatDeadline(DateTime date) {
    final day = date.day;
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = "th";
    } else {
      switch (day % 10) {
        case 1:
          suffix = "st";
          break;
        case 2:
          suffix = "nd";
          break;
        case 3:
          suffix = "rd";
          break;
        default:
          suffix = "th";
      }
    }
    // Format weekday and month parts
    final weekday = DateFormat("EEEE").format(date);
    final monthYear = DateFormat("MMM yyyy").format(date);
    return "$weekday $day$suffix, $monthYear";
  }

  @override
  Widget build(BuildContext context) {
    final rounds = List<LeagueSurvivorRoundsEntity>.from(
      widget.lmsGameDetails.leagueSurvivorRounds,
    );
    rounds.sort((a, b) => (a.roundNumber ?? 0).compareTo(b.roundNumber ?? 0));

    final selectedRound = rounds.firstWhere(
      (round) => round.roundNumber == selectedRoundNumber,
      orElse: () => rounds.first,
    );

    final roundSelections = widget.lmsGameDetails.historicSelections
            .where((selection) => selection.roundId == selectedRound.roundId)
            .toList() ??
        [];

    final winnersSelections =
        roundSelections.where((selection) => selection.result == true).toList();

    final failedSelectionsList = roundSelections
        .where((selection) => selection.result == false)
        .toList();

    // Get winners list
    final winners = winnersSelections.map((selection) {
      return widget.lmsGameDetails.lmsPlayers.firstWhere(
        (member) => member.profileId == selection.userId,
        orElse: () => LmsPlayersEntity(
          profileId: selection.userId,
          username: 'Unknown Member',
        ),
      );
    }).toList();

    final totalSelections = roundSelections.length;
    final successfulSelections = winnersSelections.length;
    final failedSelections =
        failedSelectionsList.isEmpty ? null : failedSelectionsList.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rounds',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Top row with round numbers
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: rounds.map((round) {
                final roundNum = round.roundNumber ?? 0;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRoundNumber = roundNum;
                    });
                  },
                  child: Container(
                    width: 60,
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: selectedRoundNumber == roundNum
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[500],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        roundNum.toString(),
                        style: TextStyle(
                          color: selectedRoundNumber == roundNum
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildGeneralRoundInformationSection(selectedRound),
                  const Divider(),
                  _buildUserInformationSection(),
                  const Divider(),
                  // _buildRoundWinnersSection(winners),
                  // const Divider(),
                  _buildRoundStatsSection(
                    totalSelections,
                    successfulSelections,
                    failedSelections,
                  ),
                  const Divider(),
                  _buildAdditionalInfoSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// General Round Information Section
  Widget _buildGeneralRoundInformationSection(
      LeagueSurvivorRoundsEntity selectedRound) {
    final currentGameweekLocked =
        widget.lmsGameDetails.gameweekLock == true ? "Yes" : "No";
    final totalPlayers = widget.lmsGameDetails.lmsPlayers.length;
    final survivorsLeft = widget.lmsGameDetails.lmsPlayers
        .where((p) => p.survivorStatus == true)
        .length;
    final currentDeadline = widget.lmsGameDetails.currentDeadline;
    final formattedDeadline = currentDeadline != null
        ? _formatDeadline(currentDeadline.toLocal())
        : 'N/A';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("General Round Information", Icons.info_outline),
          const SizedBox(height: 16.0),
          _buildInfoRow(
            'Pot Total',
            '£${selectedRound.potTotal?.toStringAsFixed(2) ?? 'N/A'}',
            Icons.monetization_on,
          ),
          _buildInfoRow(
            'Buy-In',
            '£${widget.lmsGameDetails.league.buyIn?.toStringAsFixed(2) ?? 'N/A'}',
            Icons.attach_money,
          ),
          _buildInfoRow(
            'End Date',
            selectedRound.endDate?.toLocal().toString() ?? 'N/A',
            Icons.date_range,
          ),
          _buildInfoRow(
            'Current Gameweek Selection Locked',
            currentGameweekLocked,
            Icons.lock,
          ),
          _buildInfoRow(
            'Players Remaining',
            '$survivorsLeft / $totalPlayers',
            Icons.people,
          ),
          _buildInfoRow(
            'Current Deadline',
            formattedDeadline,
            Icons.timer,
          ),
        ],
      ),
    );
  }

  /// User Information Section
  Widget _buildUserInformationSection() {
    final paidBuyIn = widget.lmsGameDetails.hasPaidBuyIn == true ? "Yes" : "No";
    final currentUserSurvivorStatus =
        widget.lmsGameDetails.survivorStatus == true ? "Yes" : "No";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("User Information", Icons.person),
          const SizedBox(height: 16.0),
          _buildInfoRow('Paid Buy-In', paidBuyIn, Icons.attach_money),
          _buildInfoRow(
              'Survivor Status', currentUserSurvivorStatus, Icons.check),
        ],
      ),
    );
  }

  Widget _buildRoundWinnersSection(List<LmsPlayersEntity> winners) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Round Winners", Icons.emoji_events),
          const SizedBox(height: 16.0),
          if (winners.isEmpty)
            const Text('No winners for this round.')
          else
            Column(
              children: winners.map((winner) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(winner.username ?? 'Unknown Member'),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildRoundStatsSection(
      int totalSelections, int successfulSelections, int? failedSelections) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Round Stats", Icons.bar_chart),
          const SizedBox(height: 16.0),
          _buildInfoRow('Total Selections', '$totalSelections', Icons.list_alt),
          _buildInfoRow('Successful Selections', '$successfulSelections',
              Icons.check_circle),
          if (failedSelections != null)
            _buildInfoRow(
                'Failed Selections', '$failedSelections', Icons.cancel),
        ],
      ),
    );
  }

  /// Additional Info Section
  Widget _buildAdditionalInfoSection() {
    final league = widget.lmsGameDetails.league;
    final totalRounds = widget.lmsGameDetails.leagueSurvivorRounds.length;
    final totalHistoricSelections =
        widget.lmsGameDetails.historicSelections.length;
    final totalPlayers = widget.lmsGameDetails.lmsPlayers.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Additional Info", Icons.info),
          const SizedBox(height: 16.0),
          _buildInfoRow(
              'Historic Selections', '$totalHistoricSelections', Icons.history),
          _buildInfoRow('Total Players', '$totalPlayers', Icons.people_alt),
        ],
      ),
    );
  }

  /// Reusable Section Title Widget
  Widget _buildSectionTitle(String title, IconData iconData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        Icon(iconData, color: Theme.of(context).colorScheme.primary),
      ],
    );
  }

  /// Reusable Info Row Widget with increased spacing.
  Widget _buildInfoRow(String title, String value, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8.0),
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
