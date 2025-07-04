// lms_game_event.dart

part of 'lms_game_bloc.dart';

abstract class LmsGameEvent extends Equatable {
  const LmsGameEvent();

  @override
  List<Object?> get props => [];
}

class FetchLmsGameDetails extends LmsGameEvent {
  final String leagueId;

  const FetchLmsGameDetails(this.leagueId);

  @override
  List<Object?> get props => [leagueId];
}

class LeaveLmsGameEvent extends LmsGameEvent {
  final String leagueId;

  const LeaveLmsGameEvent(this.leagueId);

  @override
  List<Object?> get props => [leagueId];
}
