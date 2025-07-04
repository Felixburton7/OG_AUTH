import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/bet_challenge_card.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/bet_offer_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';

class HeadToHeadSettledPage extends StatelessWidget {
  final List<BetOfferEntity> settledBetOffers;
  final List<BetChallengeEntity>? settledChallenges;
  final List<FixtureEntity> fixtures;
  final H2hGameDetails gameDetails;

  const HeadToHeadSettledPage({
    Key? key,
    required this.settledBetOffers,
    this.settledChallenges,
    required this.fixtures,
    required this.gameDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

    // Get all inactive challenges (including declined/cancelled)
    final inactiveChallenges = settledChallenges
            ?.where((challenge) =>
                challenge.challengerId == currentUserId &&
                (challenge.status.toLowerCase() == 'settled' ||
                    challenge.status.toLowerCase() == 'declined' ||
                    challenge.status.toLowerCase() == 'cancelled'))
            .toList() ??
        [];

    // Get all challenges to my offers that are inactive
    final inactiveChallengesToMyOffers = settledChallenges?.where((challenge) {
          // Find if this challenge is for one of my bet offers
          final relatedBetOffer = settledBetOffers.any((offer) =>
              offer.betId == challenge.betId &&
              offer.creatorId == currentUserId);

          return relatedBetOffer &&
              challenge.challengerId != currentUserId &&
              (challenge.status.toLowerCase() == 'settled' ||
                  challenge.status.toLowerCase() == 'declined' ||
                  challenge.status.toLowerCase() == 'cancelled');
        }).toList() ??
        [];

    final hasSettled = settledBetOffers.isNotEmpty ||
        inactiveChallenges.isNotEmpty ||
        inactiveChallengesToMyOffers.isNotEmpty;

    if (!hasSettled) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "You don't have any settled bets yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Completed, cancelled, and declined bets will appear here",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Settled Bet Offers Section
        if (settledBetOffers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "My Settled Bet Offers",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...settledBetOffers.map((bet) => BetOfferCard(
                betOffer: bet,
                fixture: _findFixture(bet.fixtureId),
                gameDetails: gameDetails,
                allChallenges: settledChallenges,
              )),
        ],

        // My Inactive Challenges Section
        if (inactiveChallenges.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              "My Settled Challenges",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...inactiveChallenges.map((challenge) {
            // Find the related bet offer
            final relatedOffer = gameDetails.betOffers.firstWhere(
              (offer) => offer.betId == challenge.betId,
              orElse: () => BetOfferEntity(
                betId: '',
                creatorId: '',
                fixtureId: '',
                gameweekId: '',
                teamId: '',
                odds: 0,
                stakePerChallenge: 0,
                totalStakeCommitted: 0,
                totalStakeReturns: 0,
                challengeCount: 0,
                challengeDeclinedCount: 0,
                challengeAcceptedCount: 0,
                status: '',
                deadline: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );

            // Find the creator name
            final creatorName =
                _findUserName(gameDetails, relatedOffer.creatorId);

            return BetChallengeCard(
              betChallenge: challenge,
              relatedBetOffer: relatedOffer,
              fixture: _findFixture(relatedOffer.fixtureId),
              creatorName: creatorName,
              gameDetails: gameDetails,
            );
          }),
        ],

        // Settled Challenges to My Offers Section
        if (inactiveChallengesToMyOffers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              "Settled Challenges to My Offers",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...inactiveChallengesToMyOffers.map((challenge) {
            // Find the related bet offer
            final relatedOffer = gameDetails.betOffers.firstWhere(
              (offer) => offer.betId == challenge.betId,
              orElse: () => BetOfferEntity(
                betId: '',
                creatorId: '',
                fixtureId: '',
                gameweekId: '',
                teamId: '',
                odds: 0,
                stakePerChallenge: 0,
                totalStakeCommitted: 0,
                totalStakeReturns: 0,
                challengeCount: 0,
                challengeDeclinedCount: 0,
                challengeAcceptedCount: 0,
                status: '',
                deadline: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );

            // Find the challenger name
            final challengerName =
                _findUserName(gameDetails, challenge.challengerId);

            return BetChallengeCard(
              betChallenge: challenge,
              relatedBetOffer: relatedOffer,
              fixture: _findFixture(relatedOffer.fixtureId),
              creatorName: challengerName,
              gameDetails: gameDetails,
              isMyOffer: true,
            );
          }),
        ],

        // Add some bottom padding
        const SizedBox(height: 24),
      ],
    );
  }

  /// Look up the fixture that matches the given [fixtureId].
  FixtureEntity? _findFixture(String fixtureId) {
    try {
      return fixtures.firstWhere((f) => f.fixtureId == fixtureId);
    } catch (e) {
      return null;
    }
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
