// // lms_selections_table_state.dart

// part of 'lms_selections_table_cubit.dart';

// abstract class LmsSelectionsTableState extends Equatable {
//   const LmsSelectionsTableState();

//   @override
//   List<Object> get props => [];
// }

// class LmsSelectionsTableInitial extends LmsSelectionsTableState {}

// class LmsSelectionsTableLoading extends LmsSelectionsTableState {}

// class LmsSelectionsTableLoaded extends LmsSelectionsTableState {
//   final List<LmsPlayersEntity> lmsPlayers;
//   final List<SelectionsEntity> currentSelections;
//   final List<SelectionsEntity> historicSelections;
//   final List<SelectionsEntity> upcomingSelections;
//   final List<GameWeekDTO> gameWeeks;
//   final int playersRemaining; // New Property
//   final int totalPlayers; // New Property

//   const LmsSelectionsTableLoaded({
//     required this.lmsPlayers,
//     this.currentSelections = const [],
//     this.historicSelections = const [],
//     this.upcomingSelections = const [],
//     required this.gameWeeks,
//     required this.playersRemaining, // Initialize
//     required this.totalPlayers, // Initialize
//   });

//   @override
//   List<Object> get props => [
//         lmsPlayers,
//         ...currentSelections,
//         ...historicSelections,
//         ...upcomingSelections,
//         gameWeeks,
//         playersRemaining,
//         totalPlayers,
//       ];
// }

// class LmsSelectionsTableError extends LmsSelectionsTableState {
//   final String message;

//   const LmsSelectionsTableError(this.message);

//   @override
//   List<Object> get props => [message];
// }
part of 'lms_selections_table_cubit.dart';

abstract class LmsSelectionsTableState extends Equatable {
  const LmsSelectionsTableState();

  @override
  List<Object> get props => [];
}

class LmsSelectionsTableInitial extends LmsSelectionsTableState {}

class LmsSelectionsTableLoading extends LmsSelectionsTableState {}

class LmsSelectionsTableLoaded extends LmsSelectionsTableState {
  final List<LmsPlayersEntity> lmsPlayers;
  final List<SelectionsEntity> currentSelections;
  final List<SelectionsEntity> historicSelections;
  final int playersRemaining;
  final int totalPlayers;

  const LmsSelectionsTableLoaded({
    required this.lmsPlayers,
    required this.currentSelections,
    required this.historicSelections,
    required this.playersRemaining,
    required this.totalPlayers,
  });

  @override
  List<Object> get props => [
        lmsPlayers,
        currentSelections,
        historicSelections,
        playersRemaining,
        totalPlayers,
      ];
}

class LmsSelectionsTableError extends LmsSelectionsTableState {
  final String message;
  const LmsSelectionsTableError(this.message);

  @override
  List<Object> get props => [message];
}
