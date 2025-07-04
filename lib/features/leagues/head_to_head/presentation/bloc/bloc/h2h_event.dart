part of 'h2h_bloc.dart';

abstract class H2hEvent extends Equatable {
  const H2hEvent();
  @override
  List<Object?> get props => [];
}

class FetchH2hGameDetails extends H2hEvent {
  final String leagueId;

  const FetchH2hGameDetails({required this.leagueId});

  @override
  List<Object?> get props => [leagueId];
}
