import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_event.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_state.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/page/bet_offer_challenge_accept_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BetOfferChallengesPage extends StatefulWidget {
  final BetOfferEntity betOffer;
  final FixtureEntity fixture;
  final H2hGameDetails gameDetails;
  final List<BetChallengeEntity>? allChallenges;

  const BetOfferChallengesPage({
    Key? key,
    required this.betOffer,
    required this.fixture,
    required this.gameDetails,
    required this.allChallenges,
  }) : super(key: key);

  @override
  State<BetOfferChallengesPage> createState() => _BetOfferChallengesPageState();
}

class _BetOfferChallengesPageState extends State<BetOfferChallengesPage> {
  late BetChallengeBloc _betChallengeBloc;
  Map<String, bool> _processingChallenges = {};

  @override
  void initState() {
    super.initState();
    _betChallengeBloc = getIt<BetChallengeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the team the bet is for
    String betTeamName = "";
    if (widget.fixture.homeTeamId == widget.betOffer.teamId) {
      betTeamName = widget.fixture.homeTeamName ?? "";
    } else if (widget.fixture.awayTeamId == widget.betOffer.teamId) {
      betTeamName = widget.fixture.awayTeamName ?? "";
    }

    // Get challenges for this bet offer
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

    final List<BetChallengeEntity> pendingChallenges = widget.allChallenges
            ?.where((challenge) =>
                challenge.betId == widget.betOffer.betId &&
                challenge.challengerId != currentUserId &&
                challenge.status.toLowerCase() == 'pending')
            .toList() ??
        [];

    final List<BetChallengeEntity> acceptedChallenges = widget.allChallenges
            ?.where((challenge) =>
                challenge.betId == widget.betOffer.betId &&
                challenge.challengerId != currentUserId &&
                challenge.status.toLowerCase() == 'confirmed')
            .toList() ??
        [];

    // Calculate multiplier and potential returns
    final double multiplier = widget.betOffer.odds + 1.0;
    final potentialReturns = widget.betOffer.stakePerChallenge * multiplier;

    return BlocProvider.value(
      value: _betChallengeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bet Challenges'),
        ),
        body: BlocListener<BetChallengeBloc, BetChallengeState>(
          listener: (context, state) {
            if (state is BetChallengeOperationSuccess) {
              // Mark this challenge as no longer processing
              if (mounted) {
                setState(() {
                  _processingChallenges.clear();
                });
              }

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );

              // Refresh the H2H game details to show updated challenges
              context.read<H2hBloc>().add(
                    FetchH2hGameDetails(leagueId: widget.gameDetails.leagueId),
                  );
            } else if (state is BetChallengeOperationFailure) {
              // Mark this challenge as no longer processing
              if (mounted) {
                setState(() {
                  _processingChallenges.clear();
                });
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main bet offer information card
                  _buildBetOfferCard(betTeamName, multiplier, potentialReturns),

                  const SizedBox(height: 24),

                  // Pending Challenges Section
                  if (pendingChallenges.isNotEmpty) ...[
                    Text(
                      'Pending Challenges (${pendingChallenges.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...pendingChallenges.map((challenge) => _buildChallengeCard(
                        challenge, true, acceptedChallenges.length)),
                    const SizedBox(height: 16),
                  ] else ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          'No pending challenges',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Accepted Challenges Section
                  if (acceptedChallenges.isNotEmpty) ...[
                    Text(
                      'Accepted Challenges (${acceptedChallenges.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...acceptedChallenges.map((challenge) =>
                        _buildChallengeCard(
                            challenge, false, acceptedChallenges.length)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBetOfferCard(
      String betTeamName, double multiplier, double potentialReturns) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixture title
            Text(
              "${widget.fixture.homeTeamName ?? 'Home'} vs ${widget.fixture.awayTeamName ?? 'Away'}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Match time
            Text(
              "Match: ${_formatDateTime(widget.fixture.startTime)}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 16),

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
                    ),
                  ),
                ),
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

            // Stake and returns
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stake: £${widget.betOffer.stakePerChallenge.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        "Potential Return: £${potentialReturns.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.betOffer.status)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.betOffer.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(widget.betOffer.status),
                    ),
                  ),
                ),
              ],
            ),

            // Deadline info
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Deadline: ${_formatDateTime(widget.betOffer.deadline)}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(
      BetChallengeEntity challenge, bool isPending, int acceptedCount) {
    // Determine the challenger team (opposite of the creator's team)
    final bool creatorSelectedHomeTeam =
        widget.fixture.homeTeamId == widget.betOffer.teamId;
    final String challengerTeamName = creatorSelectedHomeTeam
        ? widget.fixture.awayTeamName ?? 'Away Team'
        : widget.fixture.homeTeamName ?? 'Home Team';

    // Find the challenger name
    final String challengerName =
        _findUserName(widget.gameDetails, challenge.challengerId);

    // Check if this challenge is being processed
    final bool isProcessing =
        _processingChallenges[challenge.challengeId] == true;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Challenge info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$challengerName bets on $challengerTeamName",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Stake: £${challenge.stake.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Created: ${_formatShortDateTime(challenge.createdAt)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Accept/Decline buttons for pending challenges
            if (isPending)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isProcessing)
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else ...[
                    // Accept button
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => _navigateToAcceptPage(
                            challenge, challengerName, acceptedCount),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Accept",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Decline button
                    InkWell(
                      onTap: () => _declineChallenge(challenge.challengeId),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Decline",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              )
            else
              // Status indicator for non-pending challenges
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "ACCEPTED",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToAcceptPage(BetChallengeEntity challenge,
      String challengerName, int acceptedCount) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BetChallengeAcceptPage(
          betChallenge: challenge,
          betOffer: widget.betOffer,
          fixture: widget.fixture,
          challengerName: challengerName,
          gameDetails: widget.gameDetails,
          currentAcceptanceCount: acceptedCount,
        ),
      ),
    );

    if (result == true) {
      // If the challenge was accepted, refresh the challenges
      context.read<H2hBloc>().add(
            FetchH2hGameDetails(leagueId: widget.gameDetails.leagueId),
          );
    }
  }

  void _declineChallenge(String challengeId) {
    // Mark this challenge as processing
    setState(() {
      _processingChallenges[challengeId] = true;
    });

    _betChallengeBloc.add(
      DeclineBetChallengeEvent(
        challengeId: challengeId,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'locked':
        return Colors.orange;
      case 'settled':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return "N/A";
    return DateFormat.yMMMd().add_jm().format(dt.toLocal());
  }

  String _formatShortDateTime(DateTime dt) {
    return DateFormat('MMM d, HH:mm').format(dt.toLocal());
  }

  /// Find the name of a user given their profile ID
  String _findUserName(H2hGameDetails gameDetails, String profileId) {
    try {
      // First try to match to a league member
      for (final member in gameDetails.leagueMembers) {
        if (member.profileId == profileId) {
          // Try to get the first and last name if available
          final firstName = member.firstName ?? '';
          final lastName = member.lastName ?? '';

          if (firstName.isNotEmpty || lastName.isNotEmpty) {
            return "$firstName $lastName".trim();
          }

          // If first/last name not available, try username
          if (member.username != null && member.username!.isNotEmpty) {
            return member.username!;
          }
        }
      }

      // If it's the current user
      if (gameDetails.profileId == profileId) {
        final name =
            "${gameDetails.profileFirstName} ${gameDetails.profileLastName}"
                .trim();
        if (name.isNotEmpty) {
          return name;
        }

        if (gameDetails.profileUsername.isNotEmpty) {
          return gameDetails.profileUsername;
        }
      }
    } catch (e) {
      // Ignore errors
    }

    // As a fallback
    return 'User ${profileId.substring(0, 4)}';
  }
}
