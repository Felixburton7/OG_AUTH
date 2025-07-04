import 'package:equatable/equatable.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';

class BetChallengeDTO extends Equatable {
  final String challengeId;
  final String betId;
  final String challengerId;
  final String challengerTeamId;
  final double stake;
  final String status;
  final String? outcome;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final DateTime? declinedAt;
  final DateTime? settledAt;

  const BetChallengeDTO({
    required this.challengeId,
    required this.betId,
    required this.challengerId,
    required this.challengerTeamId,
    required this.stake,
    required this.status,
    this.outcome,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    this.confirmedAt,
    this.cancelledAt,
    this.declinedAt,
    this.settledAt,
  });

  factory BetChallengeDTO.fromJson(Map<String, dynamic> json) {
    return BetChallengeDTO(
      challengeId: json['challenge_id'] as String? ?? '',
      betId: json['bet_id'] as String? ?? '',
      challengerId: json['challenger_id'] as String? ?? '',
      challengerTeamId: json['challenger_team_id'] as String? ?? '',
      stake: (json['stake'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      outcome: json['outcome'] as String?,
      deadline: DateTime.parse(json['deadline'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      declinedAt: json['declined_at'] != null
          ? DateTime.parse(json['declined_at'] as String)
          : null,
      settledAt: json['settled_at'] != null
          ? DateTime.parse(json['settled_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challenge_id': challengeId,
      'bet_id': betId,
      'challenger_id': challengerId,
      'challenger_team_id': challengerTeamId,
      'stake': stake,
      'status': status,
      'outcome': outcome,
      'deadline': deadline.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'declined_at': declinedAt?.toIso8601String(),
      'settled_at': settledAt?.toIso8601String(),
    };
  }

  BetChallengeEntity toEntity() {
    return BetChallengeEntity(
      challengeId: challengeId,
      betId: betId,
      challengerId: challengerId,
      challengerTeamId: challengerTeamId,
      stake: stake,
      status: status,
      outcome: outcome,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      declinedAt: declinedAt,
      settledAt: settledAt,
    );
  }

  factory BetChallengeDTO.fromEntity(BetChallengeEntity entity) {
    return BetChallengeDTO(
      challengeId: entity.challengeId,
      betId: entity.betId,
      challengerId: entity.challengerId,
      challengerTeamId: entity.challengerTeamId,
      stake: entity.stake,
      status: entity.status,
      outcome: entity.outcome,
      deadline: entity.deadline,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      confirmedAt: entity.confirmedAt,
      cancelledAt: entity.cancelledAt,
      declinedAt: entity.declinedAt,
      settledAt: entity.settledAt,
    );
  }

  @override
  List<Object?> get props => [
        challengeId,
        betId,
        challengerId,
        challengerTeamId,
        stake,
        status,
        outcome,
        deadline,
        createdAt,
        updatedAt,
        confirmedAt,
        cancelledAt,
        declinedAt,
        settledAt,
      ];
}
