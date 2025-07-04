import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/repository/h2h_repository.dart';

/// Parameter class for [CreateBetChallengeUseCase].
class CreateBetChallengeParams {
  final String betId;
  final String challengerTeamId;
  final String leagueId;
  final double stake;
  final DateTime deadline;

  CreateBetChallengeParams({
    required this.betId,
    required this.challengerTeamId,
    required this.leagueId,
    required this.stake,
    required this.deadline,
  });
}

/// Use case for creating a new bet challenge.
@injectable
class CreateBetChallengeUseCase {
  final H2hGameRepository repository;

  CreateBetChallengeUseCase(this.repository);

  /// Executes the use case to create a new bet challenge.
  Future<Either<Failure, BetChallengeEntity>> execute(
      CreateBetChallengeParams params) async {
    return await repository.createBetChallenge(
      betId: params.betId,
      challengerTeamId: params.challengerTeamId,
      leagueId: params.leagueId,
      stake: params.stake,
      deadline: params.deadline,
    );
  }
}
