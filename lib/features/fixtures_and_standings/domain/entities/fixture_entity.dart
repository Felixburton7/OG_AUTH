import 'package:equatable/equatable.dart';

class FixtureEntity extends Equatable {
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
  final String? homeTeamName; // New field
  final String? awayTeamName; // New field

  const FixtureEntity({
    this.fixtureId,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamScore,
    this.awayTeamScore,
    this.finishedStatus,
    this.gameweekId,
    this.apiGameWeekRoundId,
    this.startTime,
    this.endTime,
    this.apiFixtureId,
    this.lastUpdatedAt,
    this.homeTeamWin,
    this.awayTeamWin,
    this.delayedStatus,
    this.minute,
    this.second,
    this.halfTimeInterval,
    this.secondHalf,
    this.firstHalf,
    this.homeTeamName,
    this.awayTeamName,
  });

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
  static FixtureEntity fromJson(Map<String, dynamic> json) {
    return FixtureEntity(
      fixtureId: json['fixture_id'] as String?,
      homeTeamId: json['home_team_id'] as String?,
      awayTeamId: json['away_team_id'] as String?,
      homeTeamScore: json['home_team_score'] as int?,
      awayTeamScore: json['away_team_score'] as int?,
      finishedStatus: json['finished_status'] as bool?,
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
      homeTeamWin: json['home_team_win'] as bool?,
      awayTeamWin: json['away_team_win'] as bool?,
      delayedStatus: json['delayed_status'] as bool?,
      minute: json['minute'] as int?,
      second: json['second'] as int?,
      halfTimeInterval: json['half_time_interval'] as bool?,
      secondHalf: json['second_half'] as bool?,
      firstHalf: json['first_half'] as bool?,
      // Use the correct keys from the JSON response:
      homeTeamName: json['home_team_name'] as String?,
      awayTeamName: json['away_team_name'] as String?,
    );
  }
}
