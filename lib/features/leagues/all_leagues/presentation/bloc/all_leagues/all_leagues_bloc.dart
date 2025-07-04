// all_leagues_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/usecases/fetch_all_leagues_usecase.dart';

part 'all_leagues_event.dart';
part 'all_leagues_state.dart';

@injectable
class LeagueBloc extends Bloc<LeagueEvent, LeagueState> {
  final FetchUserLeaguesUseCase fetchUserLeaguesUseCase;

  LeagueBloc({
    required this.fetchUserLeaguesUseCase,
  }) : super(LeagueLoading()) {
    on<FetchUserLeagues>(_onFetchUserLeagues);
  }

  Future<void> _onFetchUserLeagues(
      FetchUserLeagues event, Emitter<LeagueState> emit) async {
    emit(LeagueLoading());

    try {
      final leaguesSummary = await fetchUserLeaguesUseCase.execute(NoParams());

      leaguesSummary.fold(
        (l) => emit(const LeagueError('Failed to load user leagues')),
        (r) {
          final leaguesWithActions = r.map((league) {
            return league.copyWith(
                buttonAction: _determineButtonAction(league));
          }).toList();

          emit(UserLeaguesLoaded(leagues: leaguesWithActions));
        },
      );
    } catch (e) {
      emit(const LeagueError('Failed to load user leagues.'));
    }
  }

  LeagueButtonAction _determineButtonAction(LeagueSummary leagueSummary) {
    // Case 1: Round is starting soon
    if ((leagueSummary.numberOfWeeksActive == null ||
            leagueSummary.numberOfWeeksActive == 0) &&
        leagueSummary.nextRoundStartDate != null) {
      return LeagueButtonAction.showNextRoundStartDate;
    }

    // Case 2: User is not a member
    if (!leagueSummary.isUserAMember) {
      return LeagueButtonAction.joinLeague;
    }

    // Default case
    return LeagueButtonAction.none;
  }
}
