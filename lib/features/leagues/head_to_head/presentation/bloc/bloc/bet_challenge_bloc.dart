import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/cancel_bet_challenge_usecase.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/confirm_bet_challenge_usecase.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/create_bet_challenge.dart.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/decline_bet_challenge_usecase.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_event.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_challenge_state.dart';

// Bloc Implementation
@injectable
class BetChallengeBloc extends Bloc<BetChallengeEvent, BetChallengeState> {
  final CreateBetChallengeUseCase createBetChallengeUseCase;
  final ConfirmChallengeUseCase confirmChallengeUseCase;
  final DeclineChallengeUseCase declineChallengeUseCase;
  final CancelChallengeUseCase cancelChallengeUseCase;

  BetChallengeBloc({
    required this.createBetChallengeUseCase,
    required this.confirmChallengeUseCase,
    required this.declineChallengeUseCase,
    required this.cancelChallengeUseCase,
  }) : super(BetChallengeInitial()) {
    on<CreateBetChallengeEvent>(_onCreateBetChallenge);
    on<ConfirmBetChallengeEvent>(_onConfirmBetChallenge);
    on<DeclineBetChallengeEvent>(_onDeclineBetChallenge);
    on<CancelBetChallengeEvent>(_onCancelBetChallenge);
    on<ResetBetChallengeStateEvent>(_onResetState);
  }

  Future<void> _onCreateBetChallenge(
    CreateBetChallengeEvent event,
    Emitter<BetChallengeState> emit,
  ) async {
    emit(BetChallengeCreating());

    try {
      final params = CreateBetChallengeParams(
        betId: event.betId,
        challengerTeamId: event.challengerTeamId,
        leagueId: event.leagueId,
        stake: event.stake,
        deadline: event.deadline,
      );

      final result = await createBetChallengeUseCase.execute(params);

      result.fold(
        (failure) {
          emit(BetChallengeCreationFailure(error: failure.message));
        },
        (betChallenge) {
          emit(BetChallengeCreationSuccess(
            betChallenge: betChallenge,
            message: 'Challenge accepted successfully!',
          ));
        },
      );
    } catch (e) {
      emit(BetChallengeCreationFailure(
          error: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onConfirmBetChallenge(
    ConfirmBetChallengeEvent event,
    Emitter<BetChallengeState> emit,
  ) async {
    emit(BetChallengeOperating());

    try {
      final result = await confirmChallengeUseCase.execute(event.challengeId);

      result.fold(
        (failure) {
          emit(BetChallengeOperationFailure(error: failure.message));
        },
        (betChallenge) {
          emit(BetChallengeOperationSuccess(
            betChallenge: betChallenge,
            message: 'Challenge confirmed successfully!',
          ));
        },
      );
    } catch (e) {
      emit(BetChallengeOperationFailure(
          error: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onDeclineBetChallenge(
    DeclineBetChallengeEvent event,
    Emitter<BetChallengeState> emit,
  ) async {
    emit(BetChallengeOperating());

    try {
      final result = await declineChallengeUseCase.execute(event.challengeId);

      result.fold(
        (failure) {
          emit(BetChallengeOperationFailure(error: failure.message));
        },
        (betChallenge) {
          emit(BetChallengeOperationSuccess(
            betChallenge: betChallenge,
            message: 'Challenge declined successfully!',
          ));
        },
      );
    } catch (e) {
      emit(BetChallengeOperationFailure(
          error: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onCancelBetChallenge(
    CancelBetChallengeEvent event,
    Emitter<BetChallengeState> emit,
  ) async {
    emit(BetChallengeOperating());

    try {
      final result = await cancelChallengeUseCase.execute(event.challengeId);

      result.fold(
        (failure) {
          emit(BetChallengeOperationFailure(error: failure.message));
        },
        (betChallenge) {
          emit(BetChallengeOperationSuccess(
            betChallenge: betChallenge,
            message: 'Challenge cancelled successfully!',
          ));
        },
      );
    } catch (e) {
      emit(BetChallengeOperationFailure(
          error: 'An unexpected error occurred: $e'));
    }
  }

  void _onResetState(
    ResetBetChallengeStateEvent event,
    Emitter<BetChallengeState> emit,
  ) {
    emit(BetChallengeInitial());
  }
}
