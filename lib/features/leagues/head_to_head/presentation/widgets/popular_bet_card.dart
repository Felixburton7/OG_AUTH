// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:panna_app/core/constants/colors.dart';
// import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
// import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
// import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
// import 'package:panna_app/features/leagues/head_to_head/presentation/page/bet_challenge_slip.dart';

// class PopularBetCard extends StatelessWidget {
//   final BetOfferEntity betOffer;
//   final FixtureEntity? fixture;
//   final String creatorName;
//   final H2hGameDetails gameDetails;

//   const PopularBetCard({
//     Key? key,
//     required this.betOffer,
//     required this.fixture,
//     required this.creatorName,
//     required this.gameDetails,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (fixture == null) {
//       return const SizedBox.shrink(); // Don't show if fixture is missing
//     }

//     // Determine which team the bet offer creator selected
//     final String homeTeamName = fixture!.homeTeamName ?? 'Home Team';
//     final String awayTeamName = fixture!.awayTeamName ?? 'Away Team';

//     final bool creatorSelectedHomeTeam = fixture!.homeTeamId == betOffer.teamId;

//     // The challenger will bet on the opposite team
//     final String challengerTeamName =
//         creatorSelectedHomeTeam ? awayTeamName : homeTeamName;

//     final String matchup = '$homeTeamName vs $awayTeamName';
//     final String matchTime = _formatFixtureTime(fixture!.startTime);

//     // Calculate multiplier (traditional betting format)
//     final double multiplier = betOffer.odds + 1.0;

//     // Calculate potential returns
//     final double potentialReturns = betOffer.stakePerChallenge * multiplier;

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: () => _openChallengeSlip(context),
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Match details
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       matchup,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Text(
//                     matchTime,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // Bet details
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       '$challengerTeamName to WIN or DRAW',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryGreen.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       'x${multiplier.toStringAsFixed(1)}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.darkGreen,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // Stake and returns
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Stake: £${betOffer.stakePerChallenge.toStringAsFixed(2)}',
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Potential returns: £${potentialReturns.toStringAsFixed(2)}',
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     'Created by $creatorName',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontStyle: FontStyle.italic,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _openChallengeSlip(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => BetChallengeSlip(
//         betOffer: betOffer,
//         fixture: fixture!,
//         creatorName: creatorName,
//         gameDetails: gameDetails,
//       ),
//     ).then((result) {
//       if (result != null && result['success'] == true) {
//         // Refresh the parent page
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Challenge placed successfully!'),
//             backgroundColor: AppColors.primaryGreen,
//           ),
//         );
//       }
//     });
//   }

//   String _formatFixtureTime(DateTime? dateTime) {
//     if (dateTime == null) return "TBD";

//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final tomorrow = today.add(const Duration(days: 1));
//     final fixtureDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

//     if (fixtureDate == today) {
//       return "Today, ${DateFormat.jm().format(dateTime)}";
//     } else if (fixtureDate == tomorrow) {
//       return "Tomorrow, ${DateFormat.jm().format(dateTime)}";
//     } else {
//       return "${DateFormat('MMM d').format(dateTime)}, ${DateFormat.jm().format(dateTime)}";
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/page/bet_challenge_slip.dart';

class PopularBetCard extends StatelessWidget {
  final BetOfferEntity betOffer;
  final FixtureEntity? fixture;
  final String creatorName;
  final H2hGameDetails gameDetails;

  const PopularBetCard({
    Key? key,
    required this.betOffer,
    required this.fixture,
    required this.creatorName,
    required this.gameDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fixture == null) {
      return const SizedBox.shrink();
    }

    // Determine which team the creator selected and which one the challenger would pick
    final String homeTeamName = fixture!.homeTeamName ?? 'Home';
    final String awayTeamName = fixture!.awayTeamName ?? 'Away';
    final bool creatorSelectedHomeTeam = fixture!.homeTeamId == betOffer.teamId;
    final String challengerTeamName =
        creatorSelectedHomeTeam ? awayTeamName : homeTeamName;

    // Calculate multiplier and returns
    final double multiplier = betOffer.odds + 1.0;
    final double returnAmount = betOffer.stakePerChallenge * multiplier;

    // Format creator name more elegantly
    String displayCreatorName = creatorName;
    if (creatorName.length > 15) {
      final parts = creatorName.split(' ');
      if (parts.length > 1) {
        displayCreatorName = "${parts.first} ${parts.last[0]}.";
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        onTap: () => _openChallengeSlip(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Creator info and multiplier in top row
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                    radius: 16,
                    child: Text(
                      displayCreatorName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    displayCreatorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.green,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "${multiplier.toStringAsFixed(1)}x",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Bet details
              Row(
                children: [
                  // Team info and bet details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Team to bet on
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                challengerTeamName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "to WIN",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Fixture details
                        Text(
                          "$homeTeamName vs $awayTeamName",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2),

                        // Match time
                        Text(
                          _formatFixtureTime(fixture!.startTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stake and Returns
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                          children: [
                            const TextSpan(text: "Stake: "),
                            TextSpan(
                              text:
                                  "£${betOffer.stakePerChallenge.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                          children: [
                            const TextSpan(text: "Return: "),
                            TextSpan(
                              text: "£${returnAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Challenge Button
              Container(
                width: double.infinity,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreen,
                      AppColors.primaryGreen.withGreen(180)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () => _openChallengeSlip(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "ACCEPT CHALLENGE",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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

  void _openChallengeSlip(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BetChallengeSlip(
        betOffer: betOffer,
        fixture: fixture!,
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
}
