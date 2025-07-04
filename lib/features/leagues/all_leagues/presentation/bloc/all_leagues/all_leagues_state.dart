part of 'all_leagues_bloc.dart';

abstract class LeagueState extends Equatable {
  const LeagueState();

  @override
  List<Object?> get props => [];
}

class LeagueLoading extends LeagueState {}

class UserLeaguesLoaded extends LeagueState {
  final List<LeagueSummary> leagues;

  const UserLeaguesLoaded({required this.leagues});

  @override
  List<Object?> get props => [leagues];
}

class LeagueError extends LeagueState {
  final String message;

  const LeagueError(this.message);

  @override
  List<Object?> get props => [message];
}
