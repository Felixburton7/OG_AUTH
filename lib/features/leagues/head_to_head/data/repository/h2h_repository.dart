import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/head_to_head/data/datasource/h2h_remote_data_source.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/repository/h2h_repository.dart';

// @Injectable(as: H2hGameRepository)
// class H2hRepositoryImpl implements H2hGameRepository {
//   final H2hGameRemoteDataSource remoteDataSource;

//   H2hRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<Either<Failure, H2hGameDetails>> fetchH2hGameDetails(
//       String leagueId) async {
//     return await remoteDataSource.fetchH2hGameDetails(leagueId);
//   }

//   @override
//   Future<Either<Failure, BetOfferEntity>> createBetOffer({
//     required String fixtureId,
//     required String teamId,
//     required String gameweekId,
//     required String leagueId,
//     required double odds,
//     required double stakeAmount,
//     required DateTime deadline,
//   }) async {
//     return await remoteDataSource.createBetOffer(
//       fixtureId: fixtureId,
//       teamId: teamId,
//       gameweekId: gameweekId,
//       leagueId: leagueId,
//       odds: odds,
//       stakeAmount: stakeAmount,
//       deadline: deadline,
//     );
//   }

//   @override
//   Future<Either<Failure, BetChallengeEntity>> createBetChallenge({
//     required String betId,
//     required String challengerTeamId,
//     required String leagueId,
//     required double stake,
//     required DateTime deadline,
//   }) async {
//     return await remoteDataSource.createBetChallenge(
//       betId: betId,
//       challengerTeamId: challengerTeamId,
//       leagueId: leagueId,
//       stake: stake,
//       deadline: deadline,
//     );
//   }

//   @override
//   Future<Either<Failure, BetChallengeEntity>> confirmBetChallenge(
//       String challengeId) async {
//     return await remoteDataSource.confirmBetChallenge(challengeId);
//   }

//   @override
//   Future<Either<Failure, BetChallengeEntity>> declineBetChallenge(
//       String challengeId) async {
//     return await remoteDataSource.declineBetChallenge(challengeId);
//   }
// }import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/head_to_head/data/datasource/h2h_remote_data_source.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/repository/h2h_repository.dart';

@Injectable(as: H2hGameRepository)
class H2hRepositoryImpl implements H2hGameRepository {
  final H2hGameRemoteDataSource remoteDataSource;

  H2hRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, H2hGameDetails>> fetchH2hGameDetails(
      String leagueId) async {
    return await remoteDataSource.fetchH2hGameDetails(leagueId);
  }

  @override
  Future<Either<Failure, BetOfferEntity>> createBetOffer({
    required String fixtureId,
    required String teamId,
    required String gameweekId,
    required String leagueId,
    required double odds,
    required double stakeAmount,
    required DateTime deadline,
  }) async {
    return await remoteDataSource.createBetOffer(
      fixtureId: fixtureId,
      teamId: teamId,
      gameweekId: gameweekId,
      leagueId: leagueId,
      odds: odds,
      stakeAmount: stakeAmount,
      deadline: deadline,
    );
  }

  @override
  Future<Either<Failure, BetChallengeEntity>> createBetChallenge({
    required String betId,
    required String challengerTeamId,
    required String leagueId,
    required double stake,
    required DateTime deadline,
  }) async {
    return await remoteDataSource.createBetChallenge(
      betId: betId,
      challengerTeamId: challengerTeamId,
      leagueId: leagueId,
      stake: stake,
      deadline: deadline,
    );
  }

  @override
  Future<Either<Failure, BetChallengeEntity>> confirmBetChallenge(
      String challengeId) async {
    return await remoteDataSource.confirmBetChallenge(challengeId);
  }

  @override
  Future<Either<Failure, BetChallengeEntity>> declineBetChallenge(
      String challengeId) async {
    return await remoteDataSource.declineBetChallenge(challengeId);
  }

  @override
  Future<Either<Failure, BetChallengeEntity>> cancelBetChallenge(
      String challengeId) async {
    return await remoteDataSource.cancelBetChallenge(challengeId);
  }
}
