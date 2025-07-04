import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/page/bet_challenge_detail_page.dart';

class BetChallengeCard extends StatelessWidget {
  final BetChallengeEntity betChallenge;
  final BetOfferEntity relatedBetOffer;
  final FixtureEntity? fixture;
  final String creatorName;
  final H2hGameDetails gameDetails;
  final bool isMyOffer;

  const BetChallengeCard({
    Key? key,
    required this.betChallenge,
    required this.relatedBetOffer,
    required this.fixture,
    required this.creatorName,
    required this.gameDetails,
    this.isMyOffer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fixture == null) {
      return const SizedBox.shrink(); // Don't show if fixture is missing
    }

    final String fixtureTitle =
        "${fixture!.homeTeamName ?? 'Home'} vs ${fixture!.awayTeamName ?? 'Away'}";
    final String matchTime = _formatFixtureTime(fixture!.startTime);

    // Determine team names
    final bool creatorSelectedHomeTeam =
        fixture!.homeTeamId == relatedBetOffer.teamId;
    final String creatorTeamName = creatorSelectedHomeTeam
        ? fixture!.homeTeamName ?? 'Home Team'
        : fixture!.awayTeamName ?? 'Away Team';
    final String challengerTeamName = creatorSelectedHomeTeam
        ? fixture!.awayTeamName ?? 'Away Team'
        : fixture!.homeTeamName ?? 'Home Team';

    // Calculate odds and returns
    final double multiplier = relatedBetOffer.odds + 1.0;
    final double potentialReturn = betChallenge.stake * multiplier;

    // Status text and color based on status
    String statusText;
    Color statusColor;

    switch (betChallenge.status.toLowerCase()) {
      case 'pending':
        if (isMyOffer) {
          statusText = "Waiting for your response";
        } else {
          statusText = "Pending waiting for $creatorName to accept bet";
        }
        statusColor = Colors.orange;
        break;
      case 'confirmed':
        statusText = "Bet offer accepted by $creatorName";
        statusColor = Colors.green;
        break;
      case 'declined':
        statusText = "Bet offer rejected by $creatorName";
        statusColor = Colors.red;
        break;
      case 'cancelled':
        statusText = "Cancelled";
        statusColor = Colors.grey;
        break;
      case 'settled':
        statusText = "Settled";
        statusColor = Colors.blue;
        break;
      default:
        statusText = betChallenge.status;
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Navigate to challenge detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BetChallengeDetailPage(
                betChallenge: betChallenge,
                relatedBetOffer: relatedBetOffer,
                fixture: fixture!,
                creatorName: creatorName,
                gameDetails: gameDetails,
                isMyOffer: isMyOffer,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Fixture title and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fixtureTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4), // Add spacing
                  Text(
                    matchTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Team selection and odds - FIX: Proper handling of long text
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isMyOffer
                          ? "$creatorName bet on $challengerTeamName to WIN"
                          : "You bet on $challengerTeamName to WIN",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // Allow two lines for long team names
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                      width: 8), // Add spacing between text and multiplier
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "x${multiplier.toStringAsFixed(1)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Challenger info and creator team - FIX: Use Expanded properly
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMyOffer
                              ? "Against your bet on $creatorTeamName"
                              : "Against $creatorName's bet on $creatorTeamName",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Stake: £${betChallenge.stake.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Potential Return: £${potentialReturn.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8), // Add spacing
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      betChallenge.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              // Status text
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                  maxLines: 2, // Allow for wrapping of long status messages
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Created date
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Created on ${_formatDateTime(betChallenge.createdAt)}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFixtureTime(DateTime? dateTime) {
    if (dateTime == null) return "TBD";

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final fixtureDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (fixtureDate == today) {
      return "Today, ${DateFormat.jm().format(dateTime)}";
    } else if (fixtureDate == tomorrow) {
      return "Tomorrow, ${DateFormat.jm().format(dateTime)}";
    } else {
      return "${DateFormat('MMM d').format(dateTime)}, ${DateFormat.jm().format(dateTime)}";
    }
  }

  String _formatDateTime(DateTime dt) {
    return DateFormat.yMMMd().add_jm().format(dt.toLocal());
  }
}
