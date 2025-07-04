import 'package:equatable/equatable.dart';

class LeagueEntity extends Equatable {
  final String? leagueId;
  final String? createdBy;
  final double? buyIn;
  final DateTime? createdAt;
  final String? leagueTitle;
  final String? addCode;
  final String? leagueAvatarUrl;
  final bool leagueIsPrivate;
  final String? firstSurvivorRoundStartDate;
  final String? leagueBio;

  const LeagueEntity({
    this.leagueId,
    this.createdBy,
    this.buyIn,
    this.createdAt,
    this.leagueTitle,
    this.addCode,
    this.leagueAvatarUrl,
    this.leagueIsPrivate = true,
    this.firstSurvivorRoundStartDate,
    this.leagueBio,
  });

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
        firstSurvivorRoundStartDate,
        leagueBio,
      ];

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'league_id': leagueId,
      'created_by': createdBy,
      'buy_in': buyIn,
      'created_at': createdAt?.toIso8601String(),
      'league_title': leagueTitle,
      'add_code': addCode,
      'league_avatar_url': leagueAvatarUrl,
      'league_is_private': leagueIsPrivate ? 1 : 0,
      'first_survivor_round_start_date': firstSurvivorRoundStartDate,
      'league_bio': leagueBio,
    };
  }

  // JSON deserialization
  static LeagueEntity fromJson(Map<String, dynamic> json) {
    return LeagueEntity(
      leagueId: json['league_id'],
      createdBy: json['created_by'],
      buyIn: json['buy_in']?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      leagueTitle: json['league_title'],
      addCode: json['add_code'],
      leagueAvatarUrl: json['league_avatar_url'],
      leagueIsPrivate: json['league_is_private'] == 1,
      firstSurvivorRoundStartDate: json['first_survivor_round_start_date'],
      leagueBio: json['league_bio'],
    );
  }

  // CopyWith method
  LeagueEntity copyWith({
    String? leagueId,
    String? createdBy,
    double? buyIn,
    DateTime? createdAt,
    String? leagueTitle,
    String? addCode,
    String? leagueAvatarUrl,
    bool? leagueIsPrivate,
    String? firstSurvivorRoundStartDate,
    String? leagueBio,
  }) {
    return LeagueEntity(
      leagueId: leagueId ?? this.leagueId,
      createdBy: createdBy ?? this.createdBy,
      buyIn: buyIn ?? this.buyIn,
      createdAt: createdAt ?? this.createdAt,
      leagueTitle: leagueTitle ?? this.leagueTitle,
      addCode: addCode ?? this.addCode,
      leagueAvatarUrl: leagueAvatarUrl ?? this.leagueAvatarUrl,
      leagueIsPrivate: leagueIsPrivate ?? this.leagueIsPrivate,
      firstSurvivorRoundStartDate:
          firstSurvivorRoundStartDate ?? this.firstSurvivorRoundStartDate,
      leagueBio: leagueBio ?? this.leagueBio,
    );
  }
}
