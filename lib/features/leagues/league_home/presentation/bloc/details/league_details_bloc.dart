// league_details_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:panna_app/features/leagues/league_home/domain/usecases/fetch_league_details_usecase.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/league_home/domain/usecases/leave_league_usecase.dart';

part 'league_details_event.dart';
part 'league_details_state.dart';

@injectable
class LeagueDetailsBloc extends Bloc<LeagueDetailsEvent, LeagueDetailsState> {
  final FetchLeagueDetailsUseCase fetchLeagueDetailsUseCase;
  final LeaveLeagueUseCase leaveLeagueUseCase;

  LeagueDetailsBloc({
    required this.fetchLeagueDetailsUseCase,
    required this.leaveLeagueUseCase,
  }) : super(LeagueDetailsLoading()) {
    on<FetchLeagueDetails>(_onFetchLeagueDetails);
    on<LeaveLeagueEvent>(_onLeaveLeague);
  }

  Future<void> _onFetchLeagueDetails(
      FetchLeagueDetails event, Emitter<LeagueDetailsState> emit) async {
    emit(LeagueDetailsLoading());

    try {
      final result = await fetchLeagueDetailsUseCase.execute(event.leagueId);

      result.fold(
        (failure) {
          emit(const LeagueDetailsError(
              'Failed to load league details.')); // Provide detailed error if needed
        },
        (leagueDetails) {
          final updatedDetails = leagueDetails.copyWith(
            buttonAction: _determineButtonAction(leagueDetails),
          );
          emit(LeagueDetailsLoaded(leagueDetails: updatedDetails));
        },
      );
    } catch (e) {
      emit(const LeagueDetailsError('An unexpected error occurred.'));
    }
  }

  Future<void> _onLeaveLeague(
      LeaveLeagueEvent event, Emitter<LeagueDetailsState> emit) async {
    emit(LeaveLeagueLoading());

    print(
        'Bloc: Dispatching LeaveLeagueEvent for League ID: ${event.leagueId}');
    try {
      final result = await leaveLeagueUseCase.execute(
        LeaveLeagueParams(leagueId: event.leagueId),
      );

      result.fold(
        (failure) {
          print('Bloc: LeaveLeague Failure - ${failure.message}');
          emit(LeaveLeagueFailure(failure.message));
        },
        (_) {
          print('Bloc: LeaveLeague Success');
          emit(LeaveLeagueSuccess());
        },
      );
    } catch (e) {
      print('Bloc: LeaveLeague Exception - $e');
      emit(const LeaveLeagueFailure('An unexpected error occurred.'));
    }
  }

  LeagueButtonAction _determineButtonAction(LeagueDetails leagueDetails) {
    // Case 1: Round is starting soon
    if ((leagueDetails.numberOfWeeksActive == 0) &&
        leagueDetails.nextRoundStartDate != null) {
      return LeagueButtonAction.showNextRoundStartDate;
    }

    // Case 2: User is not a member
    if (!leagueDetails.isUserAMember) {
      return LeagueButtonAction.joinLeague;
    }

    // Case 3: User is a member but hasn't paid the buy-in and the league is active
    if (leagueDetails.isUserAMember == true &&
        leagueDetails.hasPaidBuyIn == false &&
        leagueDetails.numberOfWeeksActive == 0) {
      return LeagueButtonAction.payBuyIn;
    }
    if (!leagueDetails.survivorStatus &&
        leagueDetails.isUserAMember &&
        !leagueDetails.hasPaidBuyIn &&
        (leagueDetails.numberOfWeeksActive > 0)) {
      return LeagueButtonAction.outOfLeague;
    }

    // Case 4: User is a member and survivorStatus is true
    if (leagueDetails.isUserAMember && leagueDetails.survivorStatus == true) {
      if (leagueDetails.currentSelection != null) {
        return LeagueButtonAction.showCurrentSelection;
      } else {
        return LeagueButtonAction.showNoSelectionMade;
      }
    }

    // Default case
    return LeagueButtonAction.none;
  }
}
