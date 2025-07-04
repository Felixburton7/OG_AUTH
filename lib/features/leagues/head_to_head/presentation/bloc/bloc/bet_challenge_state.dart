import 'package:equatable/equatable.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';

// States
abstract class BetChallengeState extends Equatable {
  const BetChallengeState();

  @override
  List<Object> get props => [];
}

class BetChallengeInitial extends BetChallengeState {}

class BetChallengeCreating extends BetChallengeState {}

class BetChallengeCreationSuccess extends BetChallengeState {
  final BetChallengeEntity betChallenge;
  final String message;

  const BetChallengeCreationSuccess({
    required this.betChallenge,
    this.message = 'Challenge created successfully!',
  });

  @override
  List<Object> get props => [betChallenge, message];
}

class BetChallengeCreationFailure extends BetChallengeState {
  final String error;

  const BetChallengeCreationFailure({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class BetChallengeOperating extends BetChallengeState {}

class BetChallengeOperationSuccess extends BetChallengeState {
  final BetChallengeEntity betChallenge;
  final String message;

  const BetChallengeOperationSuccess({
    required this.betChallenge,
    required this.message,
  });

  @override
  List<Object> get props => [betChallenge, message];
}

class BetChallengeOperationFailure extends BetChallengeState {
  final String error;

  const BetChallengeOperationFailure({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
