import 'package:equatable/equatable.dart';

class BetChallengeEntity extends Equatable {
  final String challengeId;
  final String betId;
  final String challengerId;
  final String challengerTeamId;
  final double stake;
  final String status; // e.g., 'pending', 'confirmed', 'cancelled', 'rejected'
  final String? outcome; // e.g., 'creator_win', 'challenger_win', 'void'
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final DateTime? declinedAt;
  final DateTime? settledAt;

  const BetChallengeEntity({
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

  static BetChallengeEntity fromJson(Map<String, dynamic> json) {
    return BetChallengeEntity(
      challengeId: json['challenge_id'],
      betId: json['bet_id'],
      challengerId: json['challenger_id'],
      challengerTeamId: json['challenger_team_id'],
      stake: (json['stake'] as num).toDouble(),
      status: json['status'],
      outcome: json['outcome'],
      deadline: DateTime.parse(json['deadline']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'])
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'])
          : null,
      declinedAt: json['declined_at'] != null
          ? DateTime.parse(json['declined_at'])
          : null,
      settledAt: json['settled_at'] != null
          ? DateTime.parse(json['settled_at'])
          : null,
    );
  }
}
