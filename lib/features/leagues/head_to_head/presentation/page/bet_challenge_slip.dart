import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_event.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_state.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart';

class BetChallengeSlip extends StatefulWidget {
  final BetOfferEntity betOffer;
  final FixtureEntity fixture;
  final String creatorName;
  final H2hGameDetails gameDetails;

  const BetChallengeSlip({
    Key? key,
    required this.betOffer,
    required this.fixture,
    required this.creatorName,
    required this.gameDetails,
  }) : super(key: key);

  @override
  State<BetChallengeSlip> createState() => _BetChallengeSlipState();
}

class _BetChallengeSlipState extends State<BetChallengeSlip> {
  late final BetChallengeBloc _betChallengeBloc;

  @override
  void initState() {
    super.initState();
    _betChallengeBloc = getIt<BetChallengeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the challenging team (opposite of the creator's team)
    final bool creatorSelectedHomeTeam =
        widget.fixture.homeTeamId == widget.betOffer.teamId;
    final String creatorTeamName = creatorSelectedHomeTeam
        ? widget.fixture.homeTeamName ?? 'Home Team'
        : widget.fixture.awayTeamName ?? 'Away Team';

    final String challengerTeamName = creatorSelectedHomeTeam
        ? widget.fixture.awayTeamName ?? 'Away Team'
        : widget.fixture.homeTeamName ?? 'Home Team';

    final String matchupTitle =
        "${widget.fixture.homeTeamName ?? 'Home'} vs ${widget.fixture.awayTeamName ?? 'Away'}";
    final String matchTime = _formatMatchTime(widget.fixture.startTime);

    // Calculate multiplier and potential returns
    final double multiplier = widget.betOffer.odds + 1.0;
    final double stake = widget.betOffer.stakePerChallenge;
    final double returnAmount = stake * multiplier;
    final String oppositeTeamId = creatorSelectedHomeTeam
        ? widget.fixture.awayTeamId ?? ""
        : widget.fixture.homeTeamId ?? "";

    return BlocProvider.value(
      value: _betChallengeBloc,
      child: BlocListener<BetChallengeBloc, BetChallengeState>(
        listener: (context, state) {
          if (state is BetChallengeCreationSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            // Close the bottom sheet with success result
            Navigator.pop(context, {
              'success': true,
              'challenge': state.betChallenge,
            });

            // Refresh the H2H game details (this will update both bet offers and challenges)
            context.read<H2hBloc>().add(
                  FetchH2hGameDetails(leagueId: widget.gameDetails.leagueId),
                );
          } else if (state is BetChallengeCreationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<BetChallengeBloc, BetChallengeState>(
          builder: (context, state) {
            final bool isPlacingChallenge = state is BetChallengeCreating;

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle for the bottom sheet
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Match title and odds
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            matchupTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "x${multiplier.toStringAsFixed(1)}",
                            style: const TextStyle(
                              color: AppColors.darkGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Match time
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        matchTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Team selection
                    Text(
                      "${challengerTeamName.toUpperCase()} TO WIN",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "You are betting on $challengerTeamName to win against ${widget.creatorName}'s bet on $creatorTeamName",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bet conditions
                    const Text(
                      "Bet conditions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "You are betting against ${widget.creatorName}. If your team wins, you will receive the total pot. If your team loses or draws, the pot goes to ${widget.creatorName}.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ),

                    const Spacer(),

                    const Divider(),

                    // Bottom section with stake and returns
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Accept bet challenge",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "x${multiplier.toStringAsFixed(1)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stake display and returns
                    Row(
                      children: [
                        // Stake display (non-editable)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Stake (fixed)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "£${stake.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Returns display
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Potential returns",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "£${returnAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Accept challenge button
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: isPlacingChallenge ||
                                  widget.gameDetails.profileAccountBalance <
                                      stake
                              ? null
                              : () => _acceptChallenge(oppositeTeamId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            disabledBackgroundColor: Colors.grey[400],
                          ),
                          child: isPlacingChallenge
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "PLACE CHALLENGE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // Balance
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Text(
                          "Balance: £${widget.gameDetails.profileAccountBalance.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _acceptChallenge(String challengerTeamId) {
    if (widget.gameDetails.profileAccountBalance <
        widget.betOffer.stakePerChallenge) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Insufficient balance to place this challenge')),
      );
      return;
    }

    if (challengerTeamId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team information not available')),
      );
      return;
    }

    // Create a deadline for the bet (typically same as original bet offer)
    final deadline = widget.betOffer.deadline;

    // Show a snackbar to indicate we're processing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing your challenge...')),
    );

    print('Submitting bet challenge:');
    print('  Bet ID: ${widget.betOffer.betId}');
    print('  Team ID: $challengerTeamId');
    print('  League ID: ${widget.gameDetails.leagueId}');
    print('  Stake: ${widget.betOffer.stakePerChallenge}');

    // Dispatch event to BetChallengeBloc to create a bet challenge
    _betChallengeBloc.add(
      CreateBetChallengeEvent(
        betId: widget.betOffer.betId,
        challengerTeamId: challengerTeamId,
        leagueId: widget.gameDetails.leagueId,
        stake: widget.betOffer.stakePerChallenge,
        deadline: deadline,
      ),
    );
  }

  String _formatMatchTime(DateTime? dateTime) {
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
