import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';

class LeagueSurvivorRoundsDTO {
  final String? roundId;
  final String? leagueId;
  final int? roundNumber;
  final String? endDate;
  final bool? isActiveStatus;
  final int? survivorCount;
  final String? createdAt;
  final int? numberOfWeeksActive;
  final double? potTotal;
  final String? survivorRoundStartDate;

  LeagueSurvivorRoundsDTO({
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
  });

  factory LeagueSurvivorRoundsDTO.fromJson(Map<String, dynamic> json) {
    return LeagueSurvivorRoundsDTO(
      roundId: json['round_id'] as String?,
      leagueId: json['league_id'] as String?,
      roundNumber: json['round_number'] as int?,
      endDate: json['end_date'] as String?,
      isActiveStatus: json['is_active_status'] as bool?,
      survivorCount: json['survivor_count'] as int?,
      createdAt: json['created_at'] as String?,
      numberOfWeeksActive: json['number_of_weeks_active'] as int?,
      potTotal: (json['pot_total'] as num?)?.toDouble(),
      survivorRoundStartDate: json['survivor_round_start_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'round_id': roundId,
      'league_id': leagueId,
      'round_number': roundNumber,
      'end_date': endDate,
      'is_active_status': isActiveStatus,
      'survivor_count': survivorCount,
      'created_at': createdAt,
      'number_of_weeks_active': numberOfWeeksActive,
      'pot_total': potTotal,
      'survivor_round_start_date': survivorRoundStartDate,
    };
  }

  LeagueSurvivorRoundsEntity toEntity() {
    return LeagueSurvivorRoundsEntity(
      roundId: roundId,
      leagueId: leagueId,
      roundNumber: roundNumber,
      endDate: endDate != null ? DateTime.parse(endDate!) : null,
      isActiveStatus: isActiveStatus,
      survivorCount: survivorCount,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      numberOfWeeksActive: numberOfWeeksActive,
      potTotal: potTotal,
      survivorRoundStartDate: survivorRoundStartDate,
    );
  }
}
