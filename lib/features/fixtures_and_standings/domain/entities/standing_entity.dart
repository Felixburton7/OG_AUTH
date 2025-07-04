import 'package:equatable/equatable.dart';

class StandingsEntity extends Equatable {
  final String? standingsTeamId;
  final String? teamName;
  final int? played;
  final int? won;
  final int? drawn;
  final int? lost;
  final int? goalsFor;
  final int? goalsAgainst;
  final int? goalDifference;
  final int? points;

  const StandingsEntity({
    this.standingsTeamId,
    this.teamName,
    this.played,
    this.won,
    this.drawn,
    this.lost,
    this.goalsFor,
    this.goalsAgainst,
    this.goalDifference,
    this.points,
  });

  @override
  List<Object?> get props => [
        standingsTeamId,
        teamName,
        played,
        won,
        drawn,
        lost,
        goalsFor,
        goalsAgainst,
        goalDifference,
        points,
      ];
}
