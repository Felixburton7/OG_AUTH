import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/dialog/confirmation_dialog.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_event.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_state.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart';

class BetChallengeAcceptPage extends StatefulWidget {
  final BetChallengeEntity betChallenge;
  final BetOfferEntity betOffer;
  final FixtureEntity fixture;
  final String challengerName;
  final H2hGameDetails gameDetails;
  final int currentAcceptanceCount;

  const BetChallengeAcceptPage({
    Key? key,
    required this.betChallenge,
    required this.betOffer,
    required this.fixture,
    required this.challengerName,
    required this.gameDetails,
    required this.currentAcceptanceCount,
  }) : super(key: key);

  @override
  State<BetChallengeAcceptPage> createState() => _BetChallengeAcceptPageState();
}

class _BetChallengeAcceptPageState extends State<BetChallengeAcceptPage> {
  late final BetChallengeBloc _betChallengeBloc;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _betChallengeBloc = getIt<BetChallengeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // Determine team names
    final bool creatorSelectedHomeTeam =
        widget.fixture.homeTeamId == widget.betOffer.teamId;
    final String creatorTeamName = creatorSelectedHomeTeam
        ? widget.fixture.homeTeamName ?? 'Home Team'
        : widget.fixture.awayTeamName ?? 'Away Team';
    final String challengerTeamName = creatorSelectedHomeTeam
        ? widget.fixture.awayTeamName ?? 'Away Team'
        : widget.fixture.homeTeamName ?? 'Home Team';

    final String matchTitle =
        "${widget.fixture.homeTeamName} vs ${widget.fixture.awayTeamName}";
    final String matchTime = _formatMatchTime(widget.fixture.startTime);

    // Calculate multiplier and returns
    final double multiplier = widget.betOffer.odds + 1.0;
    final double stake = widget.betChallenge.stake;

    // Current returns based on existing acceptances
    final double currentReturns = widget.betOffer.stakePerChallenge *
        widget.currentAcceptanceCount *
        multiplier;

    // Potential returns with this new acceptance
    final double newReturns = widget.betOffer.stakePerChallenge *
        (widget.currentAcceptanceCount + 1) *
        multiplier;

    return BlocProvider.value(
      value: _betChallengeBloc,
      child: BlocListener<BetChallengeBloc, BetChallengeState>(
        listener: (context, state) {
          if (state is BetChallengeOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            // Refresh the H2H game details and go back
            context.read<H2hBloc>().add(
                  FetchH2hGameDetails(leagueId: widget.gameDetails.leagueId),
                );
            Navigator.pop(context, true);
            Navigator.pop(
                context, true); // Pop twice to go back to the challenges list
          } else if (state is BetChallengeOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isProcessing = false;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Accept Bet Challenge'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match title and odds
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          matchTitle,
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
                    "${creatorTeamName.toUpperCase()} TO WIN",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "Your bet on $creatorTeamName vs ${widget.challengerName}'s bet on $challengerTeamName",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Current acceptances section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Bet with ${widget.currentAcceptanceCount} acceptance${widget.currentAcceptanceCount != 1 ? 's' : ''}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Stake: £${(widget.betOffer.stakePerChallenge * widget.currentAcceptanceCount).toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Returns: £${currentReturns.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // New acceptance section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bet with ${widget.currentAcceptanceCount + 1} acceptance${widget.currentAcceptanceCount + 1 != 1 ? 's' : ''}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Adding: £${stake.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "New Returns: £${newReturns.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Challenge details
                  const Text(
                    "Challenge details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Challenger: ${widget.challengerName}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Team: $challengerTeamName",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Stake: £${stake.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Date: ${_formatDate(widget.betChallenge.createdAt)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Accept button
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: _isProcessing
                            ? null
                            : () => _showConfirmationDialog(
                                context,
                                widget.challengerName,
                                stake,
                                challengerTeamName),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          disabledBackgroundColor: Colors.grey[400],
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "ACCEPT BET CHALLENGE",
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
                        "Your Balance: £${widget.gameDetails.profileAccountBalance.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String challengerName,
      double stakeAmount, String challengerTeamName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          title: "Accept Challenge",
          content:
              "You are accepting ${challengerName}'s bet on $challengerTeamName. £${stakeAmount.toStringAsFixed(2)} will be deducted from your account balance.\n\nDo you want to proceed?",
          confirmText: "Accept",
          cancelText: "Cancel",
          onConfirm: () {
            Navigator.pop(dialogContext); // Close the dialog
            _acceptChallenge();
          },
        );
      },
    );
  }

  void _acceptChallenge() {
    setState(() {
      _isProcessing = true;
    });

    _betChallengeBloc.add(
      ConfirmBetChallengeEvent(
        challengeId: widget.betChallenge.challengeId,
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

  String _formatDate(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }
}
