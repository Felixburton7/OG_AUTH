part of 'view_members_selections_cubit.dart';

abstract class ViewMembersSelectionsState extends Equatable {
  const ViewMembersSelectionsState();

  @override
  List<Object?> get props => [];
}

class ViewMembersSelectionsInitial extends ViewMembersSelectionsState {}

class ViewMembersSelectionsLoading extends ViewMembersSelectionsState {}

class ViewMembersSelectionsLoaded extends ViewMembersSelectionsState {
  final List<LeagueMembersEntity> leagueMembers;
  final List<SelectionsEntity> currentSelections;
  final List<SelectionsEntity> historicSelections;
  final List<SelectionsEntity> upcomingSelections; // Added upcomingSelections
  final List<GameWeekDTO> gameWeeks;

  const ViewMembersSelectionsLoaded({
    required this.leagueMembers,
    this.currentSelections = const [],
    this.historicSelections = const [],
    this.upcomingSelections = const [], // Initialize with empty list
    required this.gameWeeks,
  });

  @override
  List<Object?> get props => [
        leagueMembers,
        currentSelections.isEmpty ? [] : currentSelections,
        historicSelections.isEmpty ? [] : historicSelections,
        upcomingSelections.isEmpty ? [] : upcomingSelections,
        gameWeeks,
      ];
}

class ViewMembersSelectionsError extends ViewMembersSelectionsState {
  final String message;

  const ViewMembersSelectionsError(this.message);

  @override
  List<Object?> get props => [message];
}
