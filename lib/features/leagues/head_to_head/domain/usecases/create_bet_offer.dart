import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/repository/h2h_repository.dart';

/// Parameter class for [CreateBetOfferUseCase].
class CreateBetOfferParams {
  final String fixtureId;
  final String teamId;
  final String gameweekId;
  final String leagueId;
  final double odds;
  final double stakeAmount;
  final DateTime deadline;

  CreateBetOfferParams({
    required this.fixtureId,
    required this.teamId,
    required this.gameweekId,
    required this.leagueId,
    required this.odds,
    required this.stakeAmount,
    required this.deadline,
  });
}

/// Use case for creating a new bet offer.
@injectable
class CreateBetOfferUseCase {
  final H2hGameRepository repository;

  CreateBetOfferUseCase(this.repository);

  /// Executes the use case to create a new bet offer.
  Future<Either<Failure, BetOfferEntity>> execute(
      CreateBetOfferParams params) async {
    return await repository.createBetOffer(
      fixtureId: params.fixtureId,
      teamId: params.teamId,
      gameweekId: params.gameweekId,
      leagueId: params.leagueId,
      odds: params.odds,
      stakeAmount: params.stakeAmount,
      deadline: params.deadline,
    );
  }
}
