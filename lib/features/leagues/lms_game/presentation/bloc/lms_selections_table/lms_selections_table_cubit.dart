// // lms_selections_table_cubit.dart

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:injectable/injectable.dart';
// import 'package:panna_app/features/fixtures_and_standings/data/mapper/game_week_DTO.dart';
// import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
// import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
// import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
// import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_players_entity.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// part 'lms_selections_table_state.dart';

// @injectable
// class LmsSelectionsTableCubit extends Cubit<LmsSelectionsTableState> {
//   LmsSelectionsTableCubit() : super(LmsSelectionsTableInitial());

//   void loadSelections(LmsGameDetails lmsGameDetails) {
//     emit(LmsSelectionsTableLoading());

//     try {
//       // Sorting members by survivor status
//       final List<LmsPlayersEntity> sortedMembers = List.from(
//         lmsGameDetails.lmsPlayers,
//       )..sort((a, b) {
//           final bool aSurvivorStatus = a.survivorStatus ?? false;
//           final bool bSurvivorStatus = b.survivorStatus ?? false;

//           if (aSurvivorStatus == bSurvivorStatus) {
//             return 0;
//           } else if (bSurvivorStatus) {
//             return 1;
//           } else {
//             return -1;
//           }
//         });

//       // Current gameweek selections
//       final List<SelectionsEntity> currentSelections =
//           lmsGameDetails.currentSelections ?? [];

//       // Historic selections
//       final List<SelectionsEntity> historicSelections =
//           lmsGameDetails.historicSelections ?? [];

//       // Retrieve upcoming selection for the current user
//       final String? currentUserId =
//           Supabase.instance.client.auth.currentUser?.id;
//       List<SelectionsEntity> upcomingSelections = [];

//       if (currentUserId != null) {
//         final upcomingSelection = lmsGameDetails.currentSelection;

//         if (upcomingSelection != null &&
//             upcomingSelection.userId == currentUserId &&
//             upcomingSelection.madeSelectionStatus == false) {
//           upcomingSelections.add(upcomingSelection);
//         }
//       }

//       // Get the number of weeks active for the current round
//       final int numberOfWeeksActive = lmsGameDetails.numberOfWeeksActive ?? 0;

//       // Create gameweek labels based on number_of_weeks_active
//       final List<GameWeekDTO> gameWeeks = List.generate(
//         numberOfWeeksActive,
//         (index) => GameWeekDTO(
//           gameweekId: '',
//           gameweekNumber: index + 1, // Ascending order
//         ),
//       );

//       // Emit loaded state with current selections, historic selections, upcoming selections, gameweeks, and new properties
//       emit(LmsSelectionsTableLoaded(
//         lmsPlayers: sortedMembers,
//         currentSelections: currentSelections,
//         historicSelections: historicSelections,
//         upcomingSelections: upcomingSelections,
//         gameWeeks: gameWeeks,
//         playersRemaining: lmsGameDetails.playersRemaining, // New Property
//         totalPlayers: lmsGameDetails.totalPlayers, // New Property
//       ));
//     } catch (e) {
//       emit(LmsSelectionsTableError('Failed to load member selections.'));
//     }
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_players_entity.dart';

part 'lms_selections_table_state.dart';

@injectable
class LmsSelectionsTableCubit extends Cubit<LmsSelectionsTableState> {
  LmsSelectionsTableCubit() : super(LmsSelectionsTableInitial());

  void loadSelections(LmsGameDetails lmsGameDetails) {
    emit(LmsSelectionsTableLoading());
    try {
      // We rely ONLY on lmsPlayers from LmsGameDetails
      final List<LmsPlayersEntity> sortedPlayers =
          List.of(lmsGameDetails.lmsPlayers);

      // Sort them by (survivorStatus desc, paidBuyIn desc, username asc) or any logic you want
      sortedPlayers.sort((a, b) {
        // If both have same survivor + buyIn, fallback to username
        if (a.survivorStatus == b.survivorStatus) {
          if (a.paidBuyIn == b.paidBuyIn) {
            return (a.username ?? '').compareTo(b.username ?? '');
          }
          // Those with paidBuyIn == true come before paidBuyIn == false
          return b.paidBuyIn.toString().compareTo(a.paidBuyIn.toString());
        }
        // Those with survivorStatus == true come first
        return b.survivorStatus
            .toString()
            .compareTo(a.survivorStatus.toString());
      });

      // Current gameweek selections -> from LmsGameDetails
      final currentSelections = lmsGameDetails.currentSelections;
      // Historic -> from LmsGameDetails
      final historicSelections = lmsGameDetails.historicSelections;

      // playersRemaining & totalPlayers direct from lmsGameDetails
      final playersRemaining = lmsGameDetails.playersRemaining;
      final totalPlayers = lmsGameDetails.totalPlayers;

      emit(LmsSelectionsTableLoaded(
        lmsPlayers: sortedPlayers,
        currentSelections: currentSelections,
        historicSelections: historicSelections,
        playersRemaining: playersRemaining,
        totalPlayers: totalPlayers,
      ));
    } catch (e) {
      emit(LmsSelectionsTableError('Failed to load the LMS Selections Table.'));
    }
  }
}
