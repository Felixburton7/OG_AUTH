part of 'current_selections_bloc.dart';

abstract class CurrentSelectionsEvent extends Equatable {
  const CurrentSelectionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCurrentFixturesEvent extends CurrentSelectionsEvent {
  final LeagueDetails leagueDetails;

  const LoadCurrentFixturesEvent({
    required this.leagueDetails,
  });

  @override
  List<Object?> get props => [leagueDetails];
}

class SelectTeamEvent extends CurrentSelectionsEvent {
  final String teamName;

  const SelectTeamEvent({required this.teamName});

  @override
  List<Object?> get props => [teamName];
}

class ConfirmTeamSelectionEvent extends CurrentSelectionsEvent {
  final String leagueId;
  final String teamName; // Change from teamId to teamName

  const ConfirmTeamSelectionEvent({
    required this.leagueId,
    required this.teamName, // Add the teamName
  });

  @override
  List<Object> get props => [leagueId, teamName];
}
