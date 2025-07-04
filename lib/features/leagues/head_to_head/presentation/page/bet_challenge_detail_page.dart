import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_event.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_state.dart';

class BetChallengeDetailPage extends StatefulWidget {
  final BetChallengeEntity betChallenge;
  final BetOfferEntity relatedBetOffer;
  final FixtureEntity fixture;
  final String creatorName;
  final H2hGameDetails gameDetails;
  final bool isMyOffer;

  const BetChallengeDetailPage({
    Key? key,
    required this.betChallenge,
    required this.relatedBetOffer,
    required this.fixture,
    required this.creatorName,
    required this.gameDetails,
    this.isMyOffer = false,
  }) : super(key: key);

  @override
  State<BetChallengeDetailPage> createState() => _BetChallengeDetailPageState();
}

class _BetChallengeDetailPageState extends State<BetChallengeDetailPage> {
  late BetChallengeBloc _betChallengeBloc;
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
        widget.fixture.homeTeamId == widget.relatedBetOffer.teamId;
    final String creatorTeamName = creatorSelectedHomeTeam
        ? widget.fixture.homeTeamName ?? 'Home Team'
        : widget.fixture.awayTeamName ?? 'Away Team';
    final String challengerTeamName = creatorSelectedHomeTeam
        ? widget.fixture.awayTeamName ?? 'Away Team'
        : widget.fixture.homeTeamName ?? 'Home Team';

    // Calculate odds and returns
    final double multiplier = widget.relatedBetOffer.odds + 1.0;
    final double stake = widget.betChallenge.stake;
    final double potentialReturn = stake * multiplier;

    // Status text and color based on status
    Color statusColor;
    String statusText;

    switch (widget.betChallenge.status.toLowerCase()) {
      case 'pending':
        statusText = "PENDING";
        statusColor = Colors.orange;
        break;
      case 'confirmed':
        statusText = "ACCEPTED";
        statusColor = Colors.green;
        break;
      case 'declined':
        statusText = "REJECTED";
        statusColor = Colors.red;
        break;
      case 'cancelled':
        statusText = "CANCELLED";
        statusColor = Colors.grey;
        break;
      case 'settled':
        statusText = "SETTLED";
        statusColor = Colors.blue;
        break;
      default:
        statusText = widget.betChallenge.status.toUpperCase();
        statusColor = Colors.grey;
    }

    final statusDisplay = widget.isMyOffer
        ? "WAITING FOR YOUR RESPONSE"
        : statusText == "PENDING"
            ? "WAITING TO BE ACCEPTED"
            : statusText;

    final bool canCancel =
        widget.betChallenge.status.toLowerCase() == 'pending' &&
            !widget.isMyOffer;

    return BlocProvider.value(
      value: _betChallengeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bet Challenge Details'),
        ),
        body: BlocConsumer<BetChallengeBloc, BetChallengeState>(
          listener: (context, state) async {
            if (state is BetChallengeOperationSuccess) {
              // Mark that we're processing to prevent multiple navigation attempts
              setState(() {
                _isProcessing = true;
              });

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                ),
              );

              // Refresh the H2H game details to show updated status
              context.read<H2hBloc>().add(
                    FetchH2hGameDetails(leagueId: widget.gameDetails.leagueId),
                  );

              // Wait for the H2H data to refresh
              await Future.delayed(const Duration(milliseconds: 800));

              // Navigate back to previous screen with success result
              if (mounted) {
                Navigator.of(context).pop(true);
              }
            } else if (state is BetChallengeOperationFailure) {
              setState(() {
                _isProcessing = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            // Show a loading indicator if we're processing or in an operation state
            if (_isProcessing || state is BetChallengeOperating) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing your request...'),
                  ],
                ),
              );
            }

            // Show the regular UI
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status header
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "STATUS: $statusText",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Match title
                    Text(
                      "${widget.fixture.homeTeamName} vs ${widget.fixture.awayTeamName}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Match time
                    Text(
                      "Match starts: ${_formatDateTime(widget.fixture.startTime)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bet details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.isMyOffer
                                ? "$challengerTeamName to WIN (Their bet)"
                                : "$challengerTeamName to WIN (Your bet)",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "x${multiplier.toStringAsFixed(1)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Opposing bet info
                    Text(
                      widget.isMyOffer
                          ? "Against your bet on $creatorTeamName"
                          : "Against ${widget.creatorName}'s bet on $creatorTeamName",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Challenge date
                    Text(
                      "Challenge created on: ${_formatDateTime(widget.betChallenge.createdAt)}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Current Bet section
                    const Text(
                      "Current Bet",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Bet creator card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isMyOffer
                                      ? "Your bet offer"
                                      : widget.creatorName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Created on ${_formatDateTime(widget.relatedBetOffer.createdAt)}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                statusDisplay,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bet ID
                    Row(
                      children: [
                        Text(
                          "PANNA Bet ID: ",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.betChallenge.challengeId,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      "Created ${_formatDateTime(widget.betChallenge.createdAt)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Bottom stake and return info
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Bet details",
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
                                "£${potentialReturn.toStringAsFixed(2)}",
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

                    // Action buttons or status
                    if (widget.isMyOffer &&
                        widget.betChallenge.status.toLowerCase() == 'pending')
                      // Accept/Reject buttons for bet offer owner
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isProcessing
                                  ? null
                                  : () => _acceptChallenge(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "ACCEPT CHALLENGE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isProcessing
                                  ? null
                                  : () => _declineChallenge(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "DECLINE CHALLENGE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (canCancel)
                      // Cancel button for challenger
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            onPressed: _isProcessing
                                ? null
                                : () => _cancelChallenge(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "CANCEL BET",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      // Status container for non-pending status
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor, width: 1),
                          ),
                          child: Text(
                            "$statusText BET",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ),

                    // Balance
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _acceptChallenge(BuildContext context) {
    _betChallengeBloc.add(
      ConfirmBetChallengeEvent(
        challengeId: widget.betChallenge.challengeId,
      ),
    );
  }

  void _declineChallenge(BuildContext context) {
    _betChallengeBloc.add(
      DeclineBetChallengeEvent(
        challengeId: widget.betChallenge.challengeId,
      ),
    );
  }

  void _cancelChallenge(BuildContext context) {
    _betChallengeBloc.add(
      CancelBetChallengeEvent(
        challengeId: widget.betChallenge.challengeId,
      ),
    );
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return "N/A";
    return DateFormat.yMMMd().add_jm().format(dt.toLocal());
  }
}
