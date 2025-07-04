import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';

/// A contract for Head-to-Head game operations
abstract class H2hGameRepository {
  /// Fetches Head-to-Head game details for a specific league
  Future<Either<Failure, H2hGameDetails>> fetchH2hGameDetails(String leagueId);

  /// Creates a new bet offer
  Future<Either<Failure, BetOfferEntity>> createBetOffer({
    required String fixtureId,
    required String teamId,
    required String gameweekId,
    required String leagueId,
    required double odds,
    required double stakeAmount,
    required DateTime deadline,
  });

  /// Creates a new bet challenge
  Future<Either<Failure, BetChallengeEntity>> createBetChallenge({
    required String betId,
    required String challengerTeamId,
    required String leagueId,
    required double stake,
    required DateTime deadline,
  });

  /// Confirms a bet challenge
  Future<Either<Failure, BetChallengeEntity>> confirmBetChallenge(
      String challengeId);

  /// Declines a bet challenge
  Future<Either<Failure, BetChallengeEntity>> declineBetChallenge(
      String challengeId);

  /// Cancels a bet challenge
  Future<Either<Failure, BetChallengeEntity>> cancelBetChallenge(
      String challengeId);
}
