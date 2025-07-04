import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/bet_challenge_card.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/widgets/bet_offer_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';

class HeadToHeadMyBetsPage extends StatelessWidget {
  final List<BetOfferEntity> myBetOffers;
  final List<BetChallengeEntity>? myBetChallenges;
  final List<FixtureEntity> fixtures;
  final H2hGameDetails gameDetails;

  const HeadToHeadMyBetsPage({
    Key? key,
    required this.myBetOffers,
    this.myBetChallenges,
    required this.fixtures,
    required this.gameDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

    // Filter active bet offers (not settled/cancelled)
    final activeBetOffers = myBetOffers
        .where((offer) =>
            offer.status.toLowerCase() != 'settled' &&
            offer.status.toLowerCase() != 'cancelled')
        .toList();

    // Get my active challenges (when I challenged someone else)
    // Only include pending and confirmed challenges (not declined/cancelled/settled)
    final activeChallenges = myBetChallenges
            ?.where((challenge) =>
                challenge.challengerId == currentUserId &&
                (challenge.status.toLowerCase() == 'pending' ||
                    challenge.status.toLowerCase() == 'confirmed'))
            .toList() ??
        [];

    final hasBets = activeBetOffers.isNotEmpty || activeChallenges.isNotEmpty;

    if (!hasBets) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_soccer, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "You don't have any active bets yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Create a new bet or challenge someone else's bet",
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
        // My Bet Offers Section
        if (activeBetOffers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Open Bets",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...activeBetOffers.map((bet) => BetOfferCard(
                betOffer: bet,
                fixture: _findFixture(bet.fixtureId),
                gameDetails: gameDetails,
                allChallenges: myBetChallenges,
              )),
        ],

        // My Challenges to Others Section
        if (activeChallenges.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              "My Challenges",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...activeChallenges.map((challenge) {
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
