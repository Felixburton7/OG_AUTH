import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/repository/league_details_repository.dart';
import 'package:panna_app/features/leagues/league_home/domain/usecases/make_current_selection_usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/repository/lms_game_repository.dart';

part 'lms_current_selections_event.dart';
part 'lms_current_selections_state.dart';

@injectable
class LmsCurrentSelectionsBloc
    extends Bloc<LmsCurrentSelectionsEvent, LmsCurrentSelectionsState> {
  final MakeCurrentSelectionUseCase makeCurrentSelectionUseCase;
  final LmsGameRepository lmsGameRepository;

  LmsCurrentSelectionsBloc(
      this.lmsGameRepository, this.makeCurrentSelectionUseCase)
      : super(LmsCurrentSelectionsInitial()) {
    on<LoadLmsCurrentFixturesEvent>(_onLoadLmsCurrentFixturesEvent);
    on<SelectLmsTeamEvent>(_onSelectLmsTeamEvent);
    on<ConfirmLmsTeamSelectionEvent>(_onConfirmLmsTeamSelectionEvent);
  }

  Future<void> _onLoadLmsCurrentFixturesEvent(LoadLmsCurrentFixturesEvent event,
      Emitter<LmsCurrentSelectionsState> emit) async {
    emit(LmsCurrentSelectionsLoading());
    try {
      final lmsGameDetailsResult = await lmsGameRepository
          .fetchLmsGameDetails(event.lmsGameDetails.league.leagueId!);

      lmsGameDetailsResult.fold(
        (failure) {
          emit(LmsCurrentSelectionsError(
              'Failed to load current fixtures: ${failure.message}'));
        },
        (lmsGameDetails) {
          final currentFixtures = lmsGameDetails.upcomingFixtures;

          // List of teams that the user can select (team names)
          List<String> selectableTeamNames = currentFixtures
              .map((fixture) => [fixture.homeTeamName, fixture.awayTeamName])
              .expand((teamNames) => teamNames)
              .whereType<String>()
              .toList();

          // Remove teams that are already selected (based on team names)
          selectableTeamNames = selectableTeamNames
              .where((teamName) =>
                  !lmsGameDetails.alreadySelectedTeams.contains(teamName))
              .toList();

          emit(LmsCurrentSelectionsLoaded(
            lmsGameDetails: lmsGameDetails,
            currentFixtures: currentFixtures,
            availableTeamNames: selectableTeamNames,
            unavailableTeamNames: lmsGameDetails.alreadySelectedTeams,
            survivorStatus: lmsGameDetails.survivorStatus,
            selectedTeamName:
                lmsGameDetails.currentSelection?.teamName, // Use team names
            hasSelectionChanged: false, // Initialize to false
            activeGameWeek: lmsGameDetails.currentGameweek,
          ));
        },
      );
    } catch (e) {
      emit(LmsCurrentSelectionsError(
          'Failed to load current fixtures: ${e.toString()}'));
    }
  }

  void _onSelectLmsTeamEvent(
      SelectLmsTeamEvent event, Emitter<LmsCurrentSelectionsState> emit) {
    if (state is LmsCurrentSelectionsLoaded) {
      final loadedState = state as LmsCurrentSelectionsLoaded;

      if (loadedState.survivorStatus == true &&
          loadedState.availableTeamNames.contains(event.teamName)) {
        emit(loadedState.copyWith(
          selectedTeamName: event.teamName,
          hasSelectionChanged: true, // Set to true when selection changes
        ));
      } else {}
    }
  }

  Future<void> _onConfirmLmsTeamSelectionEvent(
      ConfirmLmsTeamSelectionEvent event,
      Emitter<LmsCurrentSelectionsState> emit) async {
    if (state is LmsCurrentSelectionsLoaded) {
      final loadedState = state as LmsCurrentSelectionsLoaded;

      if (loadedState.selectedTeamName != null) {
        try {
          final response = await makeCurrentSelectionUseCase.execute(
            MakeCurrentSelectionParams(
              leagueId: event.leagueId,
              teamName:
                  loadedState.selectedTeamName!, // Pass the selected team name
            ),
          );

          response.fold(
            (failure) {
              emit(loadedState.copyWith(
                errorMessage: 'Failed to confirm selection: ${failure.message}',
              ));
            },
            (success) async {
              // Clear the selected team and reset hasSelectionChanged
              emit(loadedState.copyWith(
                selectedTeamName: null,
                successMessage: 'Selection confirmed successfully!',
                errorMessage: null,
                hasSelectionChanged: false, // Reset to false after confirmation
              ));

              // Optionally, reload fixtures to reflect the new selection
              add(LoadLmsCurrentFixturesEvent(
                lmsGameDetails: loadedState.lmsGameDetails,
              ));
            },
          );
        } catch (e) {
          emit(LmsCurrentSelectionsError(
              'Failed to confirm selection: ${e.toString()}'));
        }
      }
    }
  }
}
