import 'package:equatable/equatable.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';

class SelectionsDTO extends Equatable {
  final String selectionId;
  final String userId;
  final String leagueId;
  final String roundId;
  final String teamId;
  final String gameWeekId;
  final DateTime? selectionDate;
  final bool? madeSelectionStatus;

  const SelectionsDTO({
    required this.selectionId,
    required this.userId,
    required this.leagueId,
    required this.roundId,
    required this.teamId,
    required this.gameWeekId,
    this.selectionDate,
    required this.madeSelectionStatus,
  });
  factory SelectionsDTO.fromJson(Map<String, dynamic> json) {
    return SelectionsDTO(
      selectionId: json['selection_id'] as String? ?? '', // Handle null case
      userId: json['user_id'] as String? ?? '', // Handle null case
      leagueId: json['league_id'] as String? ?? '', // Handle null case
      roundId: json['round_id'] as String? ?? '', // Handle null case
      teamId: json['team_id'] as String? ?? '', // Handle null case
      gameWeekId: json['game_week'] as String? ?? '', // Handle null case
      selectionDate: json['selection_date'] != null
          ? DateTime.parse(json['selection_date'] as String)
          : DateTime
              .now(), // Handle null case with a default value or other logic
      madeSelectionStatus:
          json['made_selection_status'] as bool? ?? false, // Handle null case
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selection_id': selectionId,
      'user_id': userId,
      'league_id': leagueId,
      'round_id': roundId,
      'team_id': teamId,
      'game_week': gameWeekId,
      // 'selection_date': selectionDate.toIso8601String(),
      'made_selection_status': madeSelectionStatus,
    };
  }

  SelectionsEntity toEntity({
    required String username,
    required String teamName,
    required int gameWeekNumber,
    required bool result,
  }) {
    return SelectionsEntity(
      selectionId: selectionId,
      userId: userId,
      leagueId: leagueId,
      roundId: roundId,
      teamId: teamId,
      teamName: teamName.isNotEmpty
          ? teamName
          : 'Unknown', // Ensure teamName is not empty
      gameWeekId: gameWeekId,
      gameWeekNumber: gameWeekNumber,
      selectionDate: selectionDate,
      madeSelectionStatus: madeSelectionStatus, result: result,
    );
  }

  factory SelectionsDTO.fromEntity(SelectionsEntity entity) {
    return SelectionsDTO(
      selectionId: entity.selectionId,
      userId: entity.userId,
      leagueId: entity.leagueId,
      roundId: entity.roundId,
      teamId: entity.teamId,
      gameWeekId: entity.gameWeekId,
      madeSelectionStatus: entity.madeSelectionStatus,
      selectionDate: entity.selectionDate,
    );
  }

  @override
  List<Object?> get props => [
        selectionId,
        userId,
        leagueId,
        roundId,
        teamId,
        gameWeekId,
        selectionDate,
        madeSelectionStatus,
      ];
}
