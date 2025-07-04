import 'package:equatable/equatable.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';

// Non db columns - username
class LeagueMembersDTO extends Equatable {
  final String? leagueMemberId;
  final String? username;
  final String? profileId;
  final String? leagueId;
  final bool? survivorStatus;
  final DateTime? joinedAt;
  final bool? paidBuyIn;
  final bool? admin;

  const LeagueMembersDTO({
    this.leagueMemberId,
    this.username,
    this.profileId,
    this.leagueId,
    this.survivorStatus,
    this.joinedAt,
    this.paidBuyIn,
    this.admin,
  });

  factory LeagueMembersDTO.fromJson(Map<String, dynamic> json) {
    return LeagueMembersDTO(
      leagueMemberId: json['league_member_id'] as String?,
      profileId: json['profile_id'] as String?,
      username: json['profiles'] != null
          ? json['profiles']['username'] as String?
          : null,
      leagueId: json['league_id'] as String?,
      survivorStatus: json['survivor_status'] as bool?,
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'] as String)
          : null,
      paidBuyIn: json['paid_buy_in'] as bool?,
      admin: json['admin'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'league_member_id': leagueMemberId,
      'profile_id': profileId,
      'username': username,
      'league_id': leagueId,
      'survivor_status': survivorStatus,
      'joined_at': joinedAt?.toIso8601String(),
      'paid_buy_in': paidBuyIn,
      'admin': admin,
    };
  }

  LeagueMembersEntity toEntity() {
    return LeagueMembersEntity(
      leagueMemberId: leagueMemberId,
      profileId: profileId,
      username: username,
      leagueId: leagueId,
      survivorStatus: survivorStatus,
      joinedAt: joinedAt,
      paidBuyIn: paidBuyIn,
      admin: admin,
    );
  }

  factory LeagueMembersDTO.fromEntity(LeagueMembersEntity entity) {
    return LeagueMembersDTO(
      leagueMemberId: entity.leagueMemberId,
      profileId: entity.profileId,
      username: entity.username,
      leagueId: entity.leagueId,
      survivorStatus: entity.survivorStatus,
      joinedAt: entity.joinedAt,
      paidBuyIn: entity.paidBuyIn,
      admin: entity.admin,
    );
  }

  @override
  List<Object?> get props => [
        leagueMemberId,
        profileId,
        username,
        leagueId,
        survivorStatus,
        joinedAt,
        paidBuyIn,
        admin,
      ];
}
