part of 'league_details_bloc.dart';

abstract class LeagueDetailsState extends Equatable {
  const LeagueDetailsState();

  @override
  List<Object?> get props => [];
}

class LeagueDetailsLoading extends LeagueDetailsState {}

class LeagueDetailsLoaded extends LeagueDetailsState {
  final LeagueDetails leagueDetails;

  const LeagueDetailsLoaded({
    required this.leagueDetails,
  });

  @override
  List<Object?> get props => [leagueDetails];
}

class LeagueDetailsError extends LeagueDetailsState {
  final String message;

  const LeagueDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// New States for Leave League
class LeaveLeagueLoading extends LeagueDetailsState {}

class LeaveLeagueSuccess extends LeagueDetailsState {}

class LeaveLeagueFailure extends LeagueDetailsState {
  final String message;

  const LeaveLeagueFailure(this.message);

  @override
  List<Object?> get props => [message];
}
