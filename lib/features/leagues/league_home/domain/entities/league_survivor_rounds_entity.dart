import 'package:equatable/equatable.dart';
import 'selections_entity.dart'; // Assuming SelectionsEntity represents the gameweek selections

class LeagueSurvivorRoundsEntity extends Equatable {
  final String? roundId;
  final String? leagueId;
  final int? roundNumber;
  final DateTime? endDate;
  final bool? isActiveStatus;
  final int? survivorCount;
  final DateTime? createdAt;
  final int? numberOfWeeksActive;
  final double? potTotal;
  final String? survivorRoundStartDate;
  final List<String>? roundWinners;
  final List<LeagueSurvivorRoundsEntityGameWeek>?
      gameWeeks; // New field to store gameweek selections
  final List<String>? winnerLeagueMemberIds; // New field for winner IDs

  const LeagueSurvivorRoundsEntity({
    this.roundId,
    this.leagueId,
    this.roundNumber,
    this.endDate,
    this.isActiveStatus,
    this.survivorCount,
    this.createdAt,
    this.numberOfWeeksActive,
    this.potTotal,
    this.survivorRoundStartDate,
    this.roundWinners,
    this.gameWeeks,
    this.winnerLeagueMemberIds,
  });

  @override
  List<Object?> get props => [
        roundId,
        leagueId,
        roundNumber,
        endDate,
        isActiveStatus,
        survivorCount,
        createdAt,
        numberOfWeeksActive,
        potTotal,
        survivorRoundStartDate,
        roundWinners,
        gameWeeks,
        winnerLeagueMemberIds,
      ];

  @override
  bool get stringify => true;
}

// Assuming each gameweek has multiple selections.
class LeagueSurvivorRoundsEntityGameWeek extends Equatable {
  final int? gameWeekNumber;
  final List<SelectionsEntity>? selections;

  const LeagueSurvivorRoundsEntityGameWeek({
    this.gameWeekNumber,
    this.selections,
  });

  @override
  List<Object?> get props => [gameWeekNumber, selections];

  @override
  bool get stringify => true;
}
