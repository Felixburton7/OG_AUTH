import 'package:equatable/equatable.dart';

class BetOfferEntity extends Equatable {
  final String betId;
  final String creatorId;
  final String fixtureId;
  final String gameweekId;
  final String teamId;
  final double odds;
  final double stakePerChallenge;
  final double totalStakeCommitted;
  final double totalStakeReturns;
  final int challengeCount;
  final int challengeDeclinedCount;
  final int challengeAcceptedCount;
  final String status; // e.g., 'open', 'locked', 'settled', 'cancelled'
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? settledAt;

  const BetOfferEntity({
    required this.betId,
    required this.creatorId,
    required this.fixtureId,
    required this.gameweekId,
    required this.teamId,
    required this.odds,
    required this.stakePerChallenge,
    required this.totalStakeCommitted,
    required this.totalStakeReturns,
    required this.challengeCount,
    required this.challengeDeclinedCount,
    required this.challengeAcceptedCount,
    required this.status,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    this.settledAt,
  });

  @override
  List<Object?> get props => [
        betId,
        creatorId,
        fixtureId,
        gameweekId,
        teamId,
        odds,
        stakePerChallenge,
        totalStakeCommitted,
        totalStakeReturns,
        challengeCount,
        challengeDeclinedCount,
        challengeAcceptedCount,
        status,
        deadline,
        createdAt,
        updatedAt,
        settledAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'bet_id': betId,
      'creator_id': creatorId,
      'fixture_id': fixtureId,
      'gameweek_id': gameweekId,
      'team_id': teamId,
      'odds': odds,
      'stake_per_challenge': stakePerChallenge,
      'total_stake_committed': totalStakeCommitted,
      'total_stake_returns': totalStakeReturns,
      'challenge_count': challengeCount,
      'challenge_declined_count': challengeDeclinedCount,
      'challenge_accepted_count': challengeAcceptedCount,
      'status': status,
      'deadline': deadline.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'settled_at': settledAt?.toIso8601String(),
    };
  }

  static BetOfferEntity fromJson(Map<String, dynamic> json) {
    return BetOfferEntity(
      betId: json['bet_id'],
      creatorId: json['creator_id'],
      fixtureId: json['fixture_id'],
      gameweekId: json['gameweek_id'],
      teamId: json['team_id'],
      odds: (json['odds'] as num).toDouble(),
      stakePerChallenge: (json['stake_per_challenge'] as num).toDouble(),
      totalStakeCommitted: (json['total_stake_committed'] as num).toDouble(),
      totalStakeReturns: (json['total_stake_returns'] as num).toDouble(),
      challengeCount: json['challenge_count'],
      challengeDeclinedCount: json['challenge_declined_count'],
      challengeAcceptedCount: json['challenge_accepted_count'],
      status: json['status'],
      deadline: DateTime.parse(json['deadline']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      settledAt: json['settled_at'] != null
          ? DateTime.parse(json['settled_at'])
          : null,
    );
  }
}
