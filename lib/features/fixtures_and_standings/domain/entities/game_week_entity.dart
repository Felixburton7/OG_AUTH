import 'package:equatable/equatable.dart';

class GameWeekEntity extends Equatable {
  final String? gameweekId;
  final int? apiGameWeekRoundId;
  final int? gameweekNumber;
  final DateTime? deadline;
  final bool currentGameWeek;
  final bool upcomingGameWeek;

  const GameWeekEntity({
    this.gameweekId,
    this.apiGameWeekRoundId,
    this.gameweekNumber,
    this.deadline,
    this.currentGameWeek = false,
    this.upcomingGameWeek = false,
  });

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
