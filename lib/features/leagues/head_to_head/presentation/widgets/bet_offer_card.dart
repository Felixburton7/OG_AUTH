import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/page/bet_offer_challenges_page.dart';

class BetOfferCard extends StatelessWidget {
  final BetOfferEntity betOffer;
  final FixtureEntity? fixture;
  final H2hGameDetails gameDetails;
  final List<BetChallengeEntity>? allChallenges;

  const BetOfferCard({
    Key? key,
    required this.betOffer,
    required this.fixture,
    required this.gameDetails,
    this.allChallenges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fixture == null) {
      return const SizedBox.shrink(); // Don't show if fixture is missing
    }

    final String fixtureTitle =
        "${fixture!.homeTeamName ?? 'Home'} vs ${fixture!.awayTeamName ?? 'Away'}";
    final String matchTime = _formatFixtureTime(fixture!.startTime);

    // Determine the team the bet is for
    String betTeamName = "";
    if (fixture!.homeTeamId == betOffer.teamId) {
      betTeamName = fixture!.homeTeamName ?? "";
    } else if (fixture!.awayTeamId == betOffer.teamId) {
      betTeamName = fixture!.awayTeamName ?? "";
    }

    // Calculate multiplier and potential returns
    final double multiplier = betOffer.odds + 1.0;
    final potentialReturns = betOffer.stakePerChallenge * multiplier;

    // Count pending/accepted challenges
    final currentUserId = gameDetails.profileId;

    final pendingChallenges = allChallenges
            ?.where((challenge) =>
                challenge.betId == betOffer.betId &&
                challenge.challengerId != currentUserId &&
                challenge.status.toLowerCase() == 'pending')
            .length ??
        0;

    final acceptedChallenges = allChallenges
            ?.where((challenge) =>
                challenge.betId == betOffer.betId &&
                challenge.challengerId != currentUserId &&
                challenge.status.toLowerCase() == 'confirmed')
            .length ??
        0;

    // Status colors based on status
    Color statusColor;
    switch (betOffer.status.toLowerCase()) {
      case 'open':
        statusColor = Colors.green;
        break;
      case 'locked':
        statusColor = Colors.orange;
        break;
      case 'settled':
        statusColor = Colors.blue;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    // Define the specified highlight color
    const Color highlightColor = Color.fromARGB(255, 2, 55, 40);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Navigate to challenges page if user is the creator
          if (betOffer.creatorId == currentUserId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BetOfferChallengesPage(
                  betOffer: betOffer,
                  fixture: fixture!,
                  gameDetails: gameDetails,
                  allChallenges: allChallenges,
                ),
              ),
            );
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: highlightColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        matchTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Bet team and odds
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "$betTeamName to WIN",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: highlightColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
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

                  const SizedBox(height: 6),

                  // Stake and status info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stakes and returns - now with bold
                          // Comment out the old stake as requested
                          Text(
                            "Stake: £${betOffer.stakePerChallenge.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Potential Return: £${potentialReturns.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Challenges with icons
                          if (pendingChallenges > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.pending_actions,
                                    size: 14,
                                    color: Colors.orange[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "$pendingChallenges pending challenge${pendingChallenges > 1 ? 's' : ''}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (acceptedChallenges > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 14,
                                    color: Colors.green[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "$acceptedChallenges accepted challenge${acceptedChallenges > 1 ? 's' : ''}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Status container removed as requested

                          // Add "Click to accept" message if this is creator's offer
                          if (betOffer.creatorId == currentUserId &&
                              pendingChallenges > 0 &&
                              betOffer.status.toLowerCase() == 'open')
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Text(
                                    "Click to accept challenges",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 12,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // Deadline info
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      "Deadline: ${DateFormat.jm().format(betOffer.deadline)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Badge indicator for pending challenges
            if (pendingChallenges > 0 && betOffer.creatorId == currentUserId)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      pendingChallenges.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
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
