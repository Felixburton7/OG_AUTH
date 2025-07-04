import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/enums/lms_game/lms_league_button_action.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/usecases/fetch_lms_home_details_usecase.dart';
import 'package:panna_app/features/leagues/lms_game/domain/usecases/leave_lms_game_usecase.dart';
import 'package:panna_app/features/leagues/lms_game/domain/usecases/pay_buy_in_usecase.dart';

part 'lms_game_event.dart';
part 'lms_game_state.dart';

@injectable
class LmsGameBloc extends Bloc<LmsGameEvent, LmsGameState> {
  final FetchLmsGameDetailsUseCase fetchLmsGameDetailsUseCase;
  final LeaveLmsGameUseCase leaveLmsGameUseCase;
  final PayBuyInUseCase payBuyInUseCase;

  LmsGameBloc({
    required this.fetchLmsGameDetailsUseCase,
    required this.leaveLmsGameUseCase,
    required this.payBuyInUseCase,
  }) : super(LmsGameLoading()) {
    on<FetchLmsGameDetails>(_onFetchLmsGameDetails);
    on<LeaveLmsGameEvent>(_onLeaveLmsGame);
  }

  Future<void> _onFetchLmsGameDetails(
    FetchLmsGameDetails event,
    Emitter<LmsGameState> emit,
  ) async {
    emit(LmsGameLoading());
    try {
      final result = await fetchLmsGameDetailsUseCase.execute(event.leagueId);
      result.fold(
        (failure) => emit(
          // We only show a top-level error if we cannot fetch the details at all
          const LmsGameError('Failed to load LMS game details.'),
        ),
        (lmsGameDetails) {
          final updatedDetails = lmsGameDetails.copyWith(
            lmsButtonAction: determineActionButton(lmsGameDetails),
          );
          emit(LmsGameLoaded(lmsGameDetails: updatedDetails));
        },
      );
    } catch (_) {
      emit(const LmsGameError('An unexpected error occurred.'));
    }
  }

  Future<void> _onLeaveLmsGame(
    LeaveLmsGameEvent event,
    Emitter<LmsGameState> emit,
  ) async {
    emit(LeaveLmsGameLoading());

    try {
      final result = await leaveLmsGameUseCase.execute(
        LeaveLmsGameParams(leagueId: event.leagueId),
      );
      result.fold(
        (failure) => emit(LeaveLmsGameFailure(failure.message)),
        (_) => emit(LeaveLmsGameSuccess()),
      );
    } catch (_) {
      emit(const LeaveLmsGameFailure('An unexpected error occurred.'));
    }
  }

  // Decide which button or action to display in LMSHome
  LmsLeagueButtonAction determineActionButton(LmsGameDetails lmsGameDetails) {
    // Debug prints
    print(
      'Action button determination: '
      'isUserAMember=${lmsGameDetails.isUserAMember}, '
      'hasPaidBuyIn=${lmsGameDetails.hasPaidBuyIn}, '
      'numberOfWeeksActive=${lmsGameDetails.numberOfWeeksActive}, '
      'survivorStatus=${lmsGameDetails.survivorStatus}, '
      'gameweekLock=${lmsGameDetails.gameweekLock}',
    );

    // 1: Member but hasn't paid buy-in, zero weeks
    if (lmsGameDetails.isUserAMember &&
        !lmsGameDetails.hasPaidBuyIn &&
        lmsGameDetails.numberOfWeeksActive == 0 &&
        !lmsGameDetails.gameweekLock) {
      return LmsLeagueButtonAction.payBuyIn;
    }

    // // 2: Out of league
    // if (!lmsGameDetails.survivorStatus &&
    //     lmsGameDetails.isUserAMember &&
    //     !lmsGameDetails.hasPaidBuyIn &&
    //     lmsGameDetails.numberOfWeeksActive > 0) {
    //   return LmsLeagueButtonAction.outOfLeague;
    // }
    // 3: Out of league
    if (!lmsGameDetails.survivorStatus &&
        lmsGameDetails.isUserAMember &&
        lmsGameDetails.hasPaidBuyIn &&
        lmsGameDetails.numberOfWeeksActive > 0) {
      return LmsLeagueButtonAction.outOfLeague;
    }
    // 3: Out of league
    if (!lmsGameDetails.survivorStatus &&
        lmsGameDetails.isUserAMember &&
        !lmsGameDetails.hasPaidBuyIn &&
        lmsGameDetails.numberOfWeeksActive > 0) {
      return LmsLeagueButtonAction.roundInSession;
    }

    // 3: Member + survivor = true
    if (lmsGameDetails.isUserAMember && lmsGameDetails.survivorStatus) {
      if (lmsGameDetails.currentSelection != null) {
        return LmsLeagueButtonAction.showCurrentSelection;
      } else {
        return LmsLeagueButtonAction.showNoSelectionMade;
      }
    }

    // 4: Lock
    if (lmsGameDetails.gameweekLock) {
      return LmsLeagueButtonAction.selectionLocked;
    }

    // Default
    return LmsLeagueButtonAction.none;
  }
}
