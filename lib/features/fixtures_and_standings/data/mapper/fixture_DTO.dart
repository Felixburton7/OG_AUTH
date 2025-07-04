import 'package:equatable/equatable.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';

class FixtureDTO extends Equatable {
  final String? fixtureId;
  final String? homeTeamId;
  final String? awayTeamId;
  final int? homeTeamScore;
  final int? awayTeamScore;
  final bool? finishedStatus;
  final String? gameweekId;
  final int? apiGameWeekRoundId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? apiFixtureId;
  final DateTime? lastUpdatedAt;
  final bool? homeTeamWin;
  final bool? awayTeamWin;
  final bool? delayedStatus;
  final int? minute;
  final int? second;
  final bool? halfTimeInterval;
  final bool? secondHalf;
  final bool? firstHalf;
  final String? homeTeamName;
  final String? awayTeamName;

  const FixtureDTO({
    this.fixtureId,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamScore,
    this.awayTeamScore,
    this.finishedStatus = false,
    this.gameweekId,
    this.apiGameWeekRoundId,
    this.startTime,
    this.endTime,
    this.apiFixtureId,
    this.lastUpdatedAt,
    this.homeTeamWin = false,
    this.awayTeamWin = false,
    this.delayedStatus = false,
    this.minute,
    this.second,
    this.halfTimeInterval,
    this.secondHalf,
    this.firstHalf,
    this.homeTeamName,
    this.awayTeamName,
  });

  factory FixtureDTO.fromJson(Map<String, dynamic> json) {
    return FixtureDTO(
      fixtureId: json['fixture_id'] as String?,
      homeTeamId: json['home_team_id'] as String?,
      awayTeamId: json['away_team_id'] as String?,
      homeTeamScore: json['home_team_score'] as int?,
      awayTeamScore: json['away_team_score'] as int?,
      finishedStatus: json['finished_status'] as bool? ?? false,
      gameweekId: json['gameweek_id'] as String?,
      apiGameWeekRoundId: json['api_game_week_round_id'] as int?,
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : null,
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      apiFixtureId: json['api_fixture_id'] as int?,
      lastUpdatedAt: json['last_updated_at'] != null
          ? DateTime.parse(json['last_updated_at'] as String)
          : null,
      homeTeamWin: json['home_team_win'] as bool? ?? false,
      awayTeamWin: json['away_team_win'] as bool? ?? false,
      delayedStatus: json['delayed_status'] as bool? ?? false,
      minute: json['minute'] as int?,
      second: json['second'] as int?,
      halfTimeInterval: json['half_time_interval'] as bool?,
      secondHalf: json['second_half'] as bool?,
      firstHalf: json['first_half'] as bool?,
      homeTeamName: json['home_team'] != null
          ? json['home_team']['team_name'] as String
          : null,
      awayTeamName: json['away_team'] != null
          ? json['away_team']['team_name'] as String
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fixture_id': fixtureId,
      'home_team_id': homeTeamId,
      'away_team_id': awayTeamId,
      'home_team_score': homeTeamScore,
      'away_team_score': awayTeamScore,
      'finished_status': finishedStatus,
      'gameweek_id': gameweekId,
      'api_game_week_round_id': apiGameWeekRoundId,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'api_fixture_id': apiFixtureId,
      'last_updated_at': lastUpdatedAt?.toIso8601String(),
      'home_team_win': homeTeamWin,
      'away_team_win': awayTeamWin,
      'delayed_status': delayedStatus,
      'minute': minute,
      'second': second,
      'half_time_interval': halfTimeInterval,
      'second_half': secondHalf,
      'first_half': firstHalf,
      'home_team': homeTeamName,
      'away_team': awayTeamName,
    };
  }

  FixtureEntity toEntity() {
    return FixtureEntity(
      fixtureId: fixtureId,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
      homeTeamScore: homeTeamScore,
      awayTeamScore: awayTeamScore,
      finishedStatus: finishedStatus,
      gameweekId: gameweekId,
      apiGameWeekRoundId: apiGameWeekRoundId,
      startTime: startTime,
      endTime: endTime,
      apiFixtureId: apiFixtureId,
      lastUpdatedAt: lastUpdatedAt,
      homeTeamWin: homeTeamWin,
      awayTeamWin: awayTeamWin,
      delayedStatus: delayedStatus,
      minute: minute,
      second: second,
      halfTimeInterval: halfTimeInterval,
      secondHalf: secondHalf,
      firstHalf: firstHalf,
      homeTeamName: homeTeamName,
      awayTeamName: awayTeamName,
    );
  }

  factory FixtureDTO.fromEntity(FixtureEntity entity) {
    return FixtureDTO(
      fixtureId: entity.fixtureId,
      homeTeamId: entity.homeTeamId,
      awayTeamId: entity.awayTeamId,
      homeTeamScore: entity.homeTeamScore,
      awayTeamScore: entity.awayTeamScore,
      finishedStatus: entity.finishedStatus,
      gameweekId: entity.gameweekId,
      apiGameWeekRoundId: entity.apiGameWeekRoundId,
      startTime: entity.startTime,
      endTime: entity.endTime,
      apiFixtureId: entity.apiFixtureId,
      lastUpdatedAt: entity.lastUpdatedAt,
      homeTeamWin: entity.homeTeamWin,
      awayTeamWin: entity.awayTeamWin,
      delayedStatus: entity.delayedStatus,
      minute: entity.minute,
      second: entity.second,
      halfTimeInterval: entity.halfTimeInterval,
      secondHalf: entity.secondHalf,
      firstHalf: entity.firstHalf,
      homeTeamName: entity.homeTeamName,
      awayTeamName: entity.awayTeamName,
    );
  }

  @override
  List<Object?> get props => [
        fixtureId,
        homeTeamId,
        awayTeamId,
        homeTeamScore,
        awayTeamScore,
        finishedStatus,
        gameweekId,
        apiGameWeekRoundId,
        startTime,
        endTime,
        apiFixtureId,
        lastUpdatedAt,
        homeTeamWin,
        awayTeamWin,
        delayedStatus,
        minute,
        second,
        halfTimeInterval,
        secondHalf,
        firstHalf,
        homeTeamName,
        awayTeamName,
      ];
}
