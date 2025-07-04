import 'package:equatable/equatable.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/standing_entity.dart';

class StandingsDTO extends Equatable {
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

  const StandingsDTO({
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

  factory StandingsDTO.fromJson(Map<String, dynamic> json) {
    return StandingsDTO(
      standingsTeamId: json['standings_team_id'] as String?,
      teamName: json['team_name'] as String?,
      played: json['played'] as int?,
      won: json['won'] as int?,
      drawn: json['drawn'] as int?,
      lost: json['lost'] as int?,
      goalsFor: json['goals_for'] as int?,
      goalsAgainst: json['goals_against'] as int?,
      goalDifference: json['goal_difference'] as int?,
      points: json['points'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'standings_team_id': standingsTeamId,
      'team_name': teamName,
      'played': played,
      'won': won,
      'drawn': drawn,
      'lost': lost,
      'goals_for': goalsFor,
      'goals_against': goalsAgainst,
      'goal_difference': goalDifference,
      'points': points,
    };
  }

  StandingsEntity toEntity() {
    return StandingsEntity(
      standingsTeamId: standingsTeamId,
      teamName: teamName,
      played: played,
      won: won,
      drawn: drawn,
      lost: lost,
      goalsFor: goalsFor,
      goalsAgainst: goalsAgainst,
      goalDifference: goalDifference,
      points: points,
    );
  }

  factory StandingsDTO.fromEntity(StandingsEntity entity) {
    return StandingsDTO(
      standingsTeamId: entity.standingsTeamId,
      teamName: entity.teamName,
      played: entity.played,
      won: entity.won,
      drawn: entity.drawn,
      lost: entity.lost,
      goalsFor: entity.goalsFor,
      goalsAgainst: entity.goalsAgainst,
      goalDifference: entity.goalDifference,
      points: entity.points,
    );
  }

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
