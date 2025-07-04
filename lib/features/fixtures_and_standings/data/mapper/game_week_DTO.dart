import 'package:equatable/equatable.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/game_week_entity.dart';

class GameWeekDTO extends Equatable {
  final String? gameweekId;
  final int? apiGameWeekRoundId;
  final int? gameweekNumber;
  final DateTime? deadline;
  final bool currentGameWeek;
  final bool upcomingGameWeek;

  const GameWeekDTO({
    this.gameweekId,
    this.apiGameWeekRoundId,
    this.gameweekNumber,
    this.deadline,
    this.currentGameWeek = false,
    this.upcomingGameWeek = false,
  });

  factory GameWeekDTO.fromJson(Map<String, dynamic> json) {
    return GameWeekDTO(
      gameweekId: json['gameweek_id'] as String?,
      apiGameWeekRoundId: json['api_game_week_round_id'] as int?,
      gameweekNumber: json['gameweek_number'] as int?,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      currentGameWeek: json['current_game_week'] as bool? ?? false,
      upcomingGameWeek: json['upcoming_game_week'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameweek_id': gameweekId,
      'api_game_week_round_id': apiGameWeekRoundId,
      'gameweek_number': gameweekNumber,
      'deadline': deadline?.toIso8601String(),
      'current_game_week': currentGameWeek,
      'upcoming_game_week': upcomingGameWeek,
    };
  }

  GameWeekEntity toEntity() {
    return GameWeekEntity(
      gameweekId: gameweekId,
      apiGameWeekRoundId: apiGameWeekRoundId,
      gameweekNumber: gameweekNumber,
      deadline: deadline,
      currentGameWeek: currentGameWeek,
      upcomingGameWeek: upcomingGameWeek,
    );
  }

  factory GameWeekDTO.fromEntity(GameWeekEntity entity) {
    return GameWeekDTO(
      gameweekId: entity.gameweekId,
      apiGameWeekRoundId: entity.apiGameWeekRoundId,
      gameweekNumber: entity.gameweekNumber,
      deadline: entity.deadline,
      currentGameWeek: entity.currentGameWeek,
      upcomingGameWeek: entity.upcomingGameWeek,
    );
  }

  @override
  List<Object?> get props => [
        gameweekId,
        apiGameWeekRoundId,
        gameweekNumber,
        deadline,
        currentGameWeek,
        upcomingGameWeek,
      ];
}
