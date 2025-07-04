// league_details_event.dart

part of 'league_details_bloc.dart';

abstract class LeagueDetailsEvent extends Equatable {
  const LeagueDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeagueDetails extends LeagueDetailsEvent {
  final String leagueId;

  const FetchLeagueDetails(this.leagueId);

  @override
  List<Object?> get props => [leagueId];
}

// New Event: LeaveLeague
class LeaveLeagueEvent extends LeagueDetailsEvent {
  final String leagueId;

  const LeaveLeagueEvent({required this.leagueId});

  @override
  List<Object?> get props => [leagueId];
}
