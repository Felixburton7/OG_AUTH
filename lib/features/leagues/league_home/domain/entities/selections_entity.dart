import 'package:equatable/equatable.dart';

class SelectionsEntity extends Equatable {
  final String selectionId;
  final String userId;
  final String? username;
  final String leagueId;
  final String roundId;
  final String teamId;
  final String teamName;
  final String gameWeekId;
  final int gameWeekNumber;
  final DateTime? selectionDate;
  final bool? madeSelectionStatus;
  final bool? result;

  const SelectionsEntity({
    required this.selectionId,
    required this.userId,
    this.username,
    required this.leagueId,
    required this.roundId,
    required this.teamId,
    required this.teamName,
    required this.gameWeekId,
    required this.gameWeekNumber,
    this.selectionDate,
    this.madeSelectionStatus,
    this.result,
  });

  @override
  List<Object?> get props => [
        selectionId,
        userId,
        username,
        leagueId,
        roundId,
        teamId,
        teamName,
        gameWeekId,
        gameWeekNumber,
        selectionDate,
        madeSelectionStatus,
        result,
      ];

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'selection_id': selectionId,
      'user_id': userId,
      'username': username,
      'league_id': leagueId,
      'round_id': roundId,
      'team_id': teamId,
      'team_name': teamName,
      'gameweek_id': gameWeekId,
      'gameweek_number': gameWeekNumber,
      'selection_date': selectionDate?.toIso8601String(),
      'made_selection_status': madeSelectionStatus == true ? 1 : 0,
      'result': result == true ? 1 : 0,
    };
  }

  // JSON deserialization
  static SelectionsEntity fromJson(Map<String, dynamic> json) {
    return SelectionsEntity(
      selectionId: json['selection_id'],
      userId: json['user_id'],
      username: json['username'],
      leagueId: json['league_id'],
      roundId: json['round_id'],
      teamId: json['team_id'],
      teamName: json['team_name'],
      gameWeekId: json['gameweek_id'],
      gameWeekNumber: json['gameweek_number'],
      selectionDate: json['selection_date'] != null
          ? DateTime.parse(json['selection_date'])
          : null,
      madeSelectionStatus: json['made_selection_status'] == 1,
      result: json['result'] == 1,
    );
  }
}
