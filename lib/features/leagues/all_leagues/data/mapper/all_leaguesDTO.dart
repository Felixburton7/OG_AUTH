import 'package:equatable/equatable.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';

class LeagueDTO extends Equatable {
  final String? leagueId;
  final String? createdBy;
  final double? buyIn;
  final DateTime? createdAt;
  final String? leagueTitle;
  final String? addCode;
  final String? leagueAvatarUrl;
  final bool leagueIsPrivate;
  final String? firstSurvivorRoundStartDate; // Changed to String
  final String? leagueBio;

  const LeagueDTO({
    this.leagueId,
    this.createdBy,
    this.buyIn,
    this.createdAt,
    this.leagueTitle,
    this.addCode,
    this.leagueAvatarUrl,
    this.leagueIsPrivate = true,
    this.firstSurvivorRoundStartDate, // Changed to String
    this.leagueBio,
  });

  factory LeagueDTO.fromJson(Map<String, dynamic> json) {
    return LeagueDTO(
      leagueId: json['league_id'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? '',
      buyIn: json['buy_in'] != null ? (json['buy_in'] as num).toDouble() : 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      leagueTitle: json['league_title'] as String? ?? '',
      addCode: json['add_code'] as String?,
      leagueAvatarUrl: json['league_avatar_url'] as String?,
      leagueIsPrivate: json['league_is_private'] as bool? ?? true,
      firstSurvivorRoundStartDate: json['first_survivor_round_start_date']
          as String?, // Changed to String parsing
      leagueBio: json['league_bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'league_id': leagueId,
      'created_by': createdBy,
      'buy_in': buyIn,
      'created_at': createdAt?.toIso8601String(),
      'league_title': leagueTitle,
      'add_code': addCode,
      'league_avatar_url': leagueAvatarUrl,
      'league_is_private': leagueIsPrivate,
      'first_survivor_round_start_date':
          firstSurvivorRoundStartDate, // Changed to String
      'league_bio': leagueBio,
    };
  }

  LeagueDTO copyWith({
    String? leagueId,
    String? createdBy,
    double? buyIn,
    DateTime? createdAt,
    String? leagueTitle,
    String? addCode,
    String? leagueAvatarUrl,
    bool? leagueIsPrivate,
    String? firstSurvivorRoundStartDate, // Changed to String
    String? leagueBio,
  }) {
    return LeagueDTO(
      leagueId: leagueId ?? this.leagueId,
      createdBy: createdBy ?? this.createdBy,
      buyIn: buyIn ?? this.buyIn,
      createdAt: createdAt ?? this.createdAt,
      leagueTitle: leagueTitle ?? this.leagueTitle,
      addCode: addCode ?? this.addCode,
      leagueAvatarUrl: leagueAvatarUrl ?? this.leagueAvatarUrl,
      leagueIsPrivate: leagueIsPrivate ?? this.leagueIsPrivate,
      firstSurvivorRoundStartDate: firstSurvivorRoundStartDate ??
          this.firstSurvivorRoundStartDate, // Changed to String
      leagueBio: leagueBio ?? this.leagueBio,
    );
  }

  LeagueEntity toEntity() {
    return LeagueEntity(
      leagueId: leagueId,
      createdBy: createdBy,
      buyIn: buyIn,
      createdAt: createdAt,
      leagueTitle: leagueTitle,
      addCode: addCode,
      leagueAvatarUrl: leagueAvatarUrl,
      leagueIsPrivate: leagueIsPrivate,
      firstSurvivorRoundStartDate: firstSurvivorRoundStartDate, // Pass String
      leagueBio: leagueBio,
    );
  }

  factory LeagueDTO.fromEntity(LeagueEntity entity) {
    return LeagueDTO(
      leagueId: entity.leagueId ?? '',
      createdBy: entity.createdBy ?? '',
      buyIn: entity.buyIn ?? 0.0,
      createdAt: entity.createdAt ?? DateTime.now(),
      leagueTitle: entity.leagueTitle ?? '',
      addCode: entity.addCode,
      leagueAvatarUrl: entity.leagueAvatarUrl,
      leagueIsPrivate: entity.leagueIsPrivate ?? true,
      firstSurvivorRoundStartDate:
          entity.firstSurvivorRoundStartDate, // Handle String
      leagueBio: entity.leagueBio,
    );
  }

  @override
  List<Object?> get props => [
        leagueId,
        createdBy,
        buyIn,
        createdAt,
        leagueTitle,
        addCode,
        leagueAvatarUrl,
        leagueIsPrivate,
        firstSurvivorRoundStartDate, // Changed to String
        leagueBio,
      ];

  @override
  bool get stringify => true;
}
