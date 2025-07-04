part of 'lms_current_selections_bloc.dart';

sealed class LmsCurrentSelectionsEvent extends Equatable {
  const LmsCurrentSelectionsEvent();

  @override
  List<Object> get props => [];
}

class LoadLmsCurrentFixturesEvent extends LmsCurrentSelectionsEvent {
  final LmsGameDetails lmsGameDetails;

  const LoadLmsCurrentFixturesEvent({
    required this.lmsGameDetails,
  });

  @override
  List<Object> get props => [lmsGameDetails];
}

class SelectLmsTeamEvent extends LmsCurrentSelectionsEvent {
  final String teamName;

  const SelectLmsTeamEvent({required this.teamName});

  @override
  List<Object> get props => [teamName];
}

class ConfirmLmsTeamSelectionEvent extends LmsCurrentSelectionsEvent {
  final String leagueId;
  final String teamName;

  const ConfirmLmsTeamSelectionEvent({
    required this.leagueId,
    required this.teamName,
  });

  @override
  List<Object> get props => [leagueId, teamName];
}
