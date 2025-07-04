import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/fixtures_and_standings/data/mapper/game_week_DTO.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'view_members_selections_state.dart';

@injectable
class ViewMembersSelectionsCubit extends Cubit<ViewMembersSelectionsState> {
  ViewMembersSelectionsCubit() : super(ViewMembersSelectionsInitial());

  void loadSelections(LeagueDetails leagueDetails) {
    // Sorting members by survivor status
    final List<LeagueMembersEntity> sortedMembers = List.from(
      leagueDetails.leagueMembers,
    )..sort((a, b) {
        final bool aSurvivorStatus = a.survivorStatus ?? false;
        final bool bSurvivorStatus = b.survivorStatus ?? false;

        if (aSurvivorStatus == bSurvivorStatus) {
          return 0;
        } else if (bSurvivorStatus) {
          return 1;
        } else {
          return -1;
        }
      });

    // Current gameweek selections
    final List<SelectionsEntity> currentSelections =
        leagueDetails.currentSelections ?? [];

    // Historic selections
    final List<SelectionsEntity> historicSelections =
        leagueDetails.historicSelections ?? [];

    // Retrieve upcoming selection for the current user
    final String? currentUserId = Supabase.instance.client.auth.currentUser?.id;
    List<SelectionsEntity> upcomingSelections = [];

    if (currentUserId != null) {
      final upcomingSelection = leagueDetails.currentSelection;

      if (upcomingSelection != null &&
          upcomingSelection.userId == currentUserId &&
          upcomingSelection.madeSelectionStatus == false) {
        upcomingSelections.add(upcomingSelection);
      }
    }

    // Get the number of weeks active for the current round
    final int numberOfWeeksActive = leagueDetails.numberOfWeeksActive ?? 0;

    // Create gameweek labels based on number_of_weeks_active
    final List<GameWeekDTO> gameWeeks = List.generate(
      numberOfWeeksActive,
      (index) => GameWeekDTO(
        gameweekId: '',
        gameweekNumber: index + 1, // Ascending order
      ),
    );

    // Emit loaded state with current selections, historic selections, upcoming selections, and gameweeks
    try {
      emit(ViewMembersSelectionsLoaded(
        leagueMembers: sortedMembers,
        currentSelections: currentSelections,
        historicSelections: historicSelections,
        upcomingSelections: upcomingSelections,
        gameWeeks: gameWeeks,
      ));
    } catch (e) {
      emit(ViewMembersSelectionsError('Failed to load member selections.'));
    }
  }
}
