part of 'all_leagues_bloc.dart';

abstract class LeagueEvent extends Equatable {
  const LeagueEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserLeagues extends LeagueEvent {}
