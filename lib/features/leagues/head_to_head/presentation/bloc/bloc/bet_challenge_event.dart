import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';

// Events
abstract class BetChallengeEvent extends Equatable {
  const BetChallengeEvent();

  @override
  List<Object> get props => [];
}

class CreateBetChallengeEvent extends BetChallengeEvent {
  final String betId;
  final String challengerTeamId;
  final String leagueId;
  final double stake;
  final DateTime deadline;

  const CreateBetChallengeEvent({
    required this.betId,
    required this.challengerTeamId,
    required this.leagueId,
    required this.stake,
    required this.deadline,
  });

  @override
  List<Object> get props =>
      [betId, challengerTeamId, leagueId, stake, deadline];
}

class ConfirmBetChallengeEvent extends BetChallengeEvent {
  final String challengeId;

  const ConfirmBetChallengeEvent({
    required this.challengeId,
  });

  @override
  List<Object> get props => [challengeId];
}

class DeclineBetChallengeEvent extends BetChallengeEvent {
  final String challengeId;

  const DeclineBetChallengeEvent({
    required this.challengeId,
  });

  @override
  List<Object> get props => [challengeId];
}

class CancelBetChallengeEvent extends BetChallengeEvent {
  final String challengeId;

  const CancelBetChallengeEvent({
    required this.challengeId,
  });

  @override
  List<Object> get props => [challengeId];
}

class ResetBetChallengeStateEvent extends BetChallengeEvent {}
