import 'package:equatable/equatable.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';

class BetOfferDTO extends Equatable {
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
  final String status;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? settledAt;

  const BetOfferDTO({
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

  factory BetOfferDTO.fromJson(Map<String, dynamic> json) {
    return BetOfferDTO(
      betId: json['bet_id'] as String? ?? '',
      creatorId: json['creator_id'] as String? ?? '',
      fixtureId: json['fixture_id'] as String? ?? '',
      gameweekId: json['gameweek_id'] as String? ?? '',
      teamId: json['team_id'] as String? ?? '',
      odds: (json['odds'] as num?)?.toDouble() ?? 0.0,
      stakePerChallenge:
          (json['stake_per_challenge'] as num?)?.toDouble() ?? 0.0,
      totalStakeCommitted:
          (json['total_stake_committed'] as num?)?.toDouble() ?? 0.0,
      totalStakeReturns:
          (json['total_stake_returns'] as num?)?.toDouble() ?? 0.0,
      challengeCount: json['challenge_count'] as int? ?? 0,
      challengeDeclinedCount: json['challenge_declined_count'] as int? ?? 0,
      challengeAcceptedCount: json['challenge_accepted_count'] as int? ?? 0,
      status: json['status'] as String? ?? 'open',
      deadline: DateTime.parse(json['deadline'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      settledAt: json['settled_at'] != null
          ? DateTime.parse(json['settled_at'] as String)
          : null,
    );
  }

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

  BetOfferEntity toEntity() {
    return BetOfferEntity(
      betId: betId,
      creatorId: creatorId,
      fixtureId: fixtureId,
      gameweekId: gameweekId,
      teamId: teamId,
      odds: odds,
      stakePerChallenge: stakePerChallenge,
      totalStakeCommitted: totalStakeCommitted,
      totalStakeReturns: totalStakeReturns,
      challengeCount: challengeCount,
      challengeDeclinedCount: challengeDeclinedCount,
      challengeAcceptedCount: challengeAcceptedCount,
      status: status,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
      settledAt: settledAt,
    );
  }

  factory BetOfferDTO.fromEntity(BetOfferEntity entity) {
    return BetOfferDTO(
      betId: entity.betId,
      creatorId: entity.creatorId,
      fixtureId: entity.fixtureId,
      gameweekId: entity.gameweekId,
      teamId: entity.teamId,
      odds: entity.odds,
      stakePerChallenge: entity.stakePerChallenge,
      totalStakeCommitted: entity.totalStakeCommitted,
      totalStakeReturns: entity.totalStakeReturns,
      challengeCount: entity.challengeCount,
      challengeDeclinedCount: entity.challengeDeclinedCount,
      challengeAcceptedCount: entity.challengeAcceptedCount,
      status: entity.status,
      deadline: entity.deadline,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      settledAt: entity.settledAt,
    );
  }

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
}
