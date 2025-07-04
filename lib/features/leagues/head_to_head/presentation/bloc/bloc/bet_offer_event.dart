import 'package:equatable/equatable.dart';

abstract class BetOfferEvent extends Equatable {
  const BetOfferEvent();

  @override
  List<Object?> get props => [];
}

class CreateBetOfferEvent extends BetOfferEvent {
  final String fixtureId;
  final String teamId;
  final String gameweekId;
  final String leagueId;
  final double odds;
  final double stakeAmount;
  final DateTime deadline;

  const CreateBetOfferEvent({
    required this.fixtureId,
    required this.teamId,
    required this.gameweekId,
    required this.leagueId,
    required this.odds,
    required this.stakeAmount,
    required this.deadline,
  });

  @override
  List<Object?> get props => [
        fixtureId,
        teamId,
        gameweekId,
        leagueId,
        odds,
        stakeAmount,
        deadline,
      ];
}

class ResetBetOfferStateEvent extends BetOfferEvent {}
