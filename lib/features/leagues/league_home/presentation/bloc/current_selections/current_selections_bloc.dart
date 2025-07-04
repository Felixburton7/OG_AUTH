import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/repository/league_details_repository.dart';
import 'package:panna_app/features/leagues/league_home/domain/usecases/make_current_selection_usecase.dart';
import 'package:fpdart/fpdart.dart';

part 'current_selections_event.dart';
part 'current_selections_state.dart';

// current_selections_bloc.dart

@injectable
class CurrentSelectionsBloc
    extends Bloc<CurrentSelectionsEvent, CurrentSelectionsState> {
  final MakeCurrentSelectionUseCase makeCurrentSelectionUseCase;
  final LeagueDetailsRepository leagueDetailsRepository;

  CurrentSelectionsBloc(
      this.leagueDetailsRepository, this.makeCurrentSelectionUseCase)
      : super(CurrentSelectionsInitial()) {
    on<LoadCurrentFixturesEvent>(_onLoadCurrentFixturesEvent);
    on<SelectTeamEvent>(_onSelectTeamEvent);
    on<ConfirmTeamSelectionEvent>(_onConfirmTeamSelectionEvent);
  }

  Future<void> _onLoadCurrentFixturesEvent(LoadCurrentFixturesEvent event,
      Emitter<CurrentSelectionsState> emit) async {
    emit(CurrentSelectionsLoading());
    try {
      final leagueDetailsResult = await leagueDetailsRepository
          .fetchLeagueDetails(event.leagueDetails.league.leagueId!);

      leagueDetailsResult.fold(
        (failure) {
          emit(CurrentSelectionsError(
              'Failed to load current fixtures: ${failure.message}'));
        },
        (leagueDetails) {
          final currentFixtures = leagueDetails.upcomingFixtures;

          // List of teams that the user can select (team names)
          List<String> selectableTeamNames = currentFixtures
              .map((fixture) => [fixture.homeTeamName, fixture.awayTeamName])
              .expand((teamNames) => teamNames)
              .whereType<String>()
              .toList();

          // Remove teams that are already selected (based on team names)
          selectableTeamNames = selectableTeamNames
              .where((teamName) =>
                  !leagueDetails.alreadySelectedTeams.contains(teamName))
              .toList();

          emit(CurrentSelectionsLoaded(
            leagueDetails: leagueDetails,
            currentFixtures: currentFixtures,
            availableTeamNames: selectableTeamNames,
            unavailableTeamNames: leagueDetails.alreadySelectedTeams,
            survivorStatus: leagueDetails.survivorStatus,
            selectedTeamName:
                leagueDetails.currentSelection?.teamName, // Use team names
            hasSelectionChanged: false, // Initialize to false
            activeGameWeek: leagueDetails.currentGameweek,
          ));
        },
      );
    } catch (e) {
      emit(CurrentSelectionsError(
          'Failed to load current fixtures: ${e.toString()}'));
    }
  }

  void _onSelectTeamEvent(
      SelectTeamEvent event, Emitter<CurrentSelectionsState> emit) {
    if (state is CurrentSelectionsLoaded) {
      final loadedState = state as CurrentSelectionsLoaded;

      if (loadedState.survivorStatus == true &&
          loadedState.availableTeamNames.contains(event.teamName)) {
        emit(loadedState.copyWith(
          selectedTeamName: event.teamName,
          hasSelectionChanged: true, // Set to true when selection changes
        ));
      } else {}
    }
  }

  Future<void> _onConfirmTeamSelectionEvent(ConfirmTeamSelectionEvent event,
      Emitter<CurrentSelectionsState> emit) async {
    if (state is CurrentSelectionsLoaded) {
      final loadedState = state as CurrentSelectionsLoaded;

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
              add(LoadCurrentFixturesEvent(
                leagueDetails: loadedState.leagueDetails,
              ));
            },
          );
        } catch (e) {
          emit(CurrentSelectionsError(
              'Failed to confirm selection: ${e.toString()}'));
        }
      }
    }
  }
}
