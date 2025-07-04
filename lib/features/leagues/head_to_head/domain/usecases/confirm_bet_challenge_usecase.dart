import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/repository/h2h_repository.dart';

@injectable
class ConfirmChallengeUseCase {
  final H2hGameRepository repository;

  ConfirmChallengeUseCase(this.repository);

  Future<Either<Failure, BetChallengeEntity>> execute(
      String challengeId) async {
    return await repository.confirmBetChallenge(challengeId);
  }
}
