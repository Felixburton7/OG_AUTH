import 'package:equatable/equatable.dart';

class LeagueMembersEntity extends Equatable {
  final String? leagueMemberId;
  final String? username;
  final String? profileId;
  final String? leagueId;
  final bool? survivorStatus;
  final DateTime? joinedAt;
  final bool? paidBuyIn;
  final bool? admin;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? teamSupported;
  final double? accountBalance;
  final double? lmsAverage;
  final String? bio;
  final DateTime? dateOfBirth;

  // NEW FIELD:
  final String? previousPickTeamName;

  const LeagueMembersEntity({
    this.leagueMemberId,
    this.username,
    this.profileId,
    this.leagueId,
    this.survivorStatus,
    this.joinedAt,
    this.paidBuyIn,
    this.admin,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.teamSupported,
    this.accountBalance,
    this.lmsAverage,
    this.bio,
    this.dateOfBirth,
    // NEW FIELD:
    this.previousPickTeamName,
  });

  @override
  List<Object?> get props => [
        leagueMemberId,
        username,
        profileId,
        leagueId,
        survivorStatus,
        joinedAt,
        paidBuyIn,
        admin,
        firstName,
        lastName,
        avatarUrl,
        teamSupported,
        accountBalance,
        lmsAverage,
        bio,
        dateOfBirth,
        // NEW FIELD:
        previousPickTeamName,
      ];

  Map<String, dynamic> toJson() {
    return {
      'league_member_id': leagueMemberId,
      'username': username,
      'profile_id': profileId,
      'league_id': leagueId,
      'survivor_status': survivorStatus == true ? 1 : 0,
      'joined_at': joinedAt?.toIso8601String(),
      'paid_buy_in': paidBuyIn == true ? 1 : 0,
      'admin': admin == true ? 1 : 0,
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatarUrl,
      'team_supported': teamSupported,
      'account_balance': accountBalance,
      'lms_average': lmsAverage,
      'bio': bio,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      // NEW FIELD:
      'previous_pick_team_name': previousPickTeamName,
    };
  }

  static LeagueMembersEntity fromJson(Map<String, dynamic> json) {
    return LeagueMembersEntity(
      leagueMemberId: json['league_member_id'],
      username: json['username'],
      profileId: json['profile_id'],
      leagueId: json['league_id'],
      survivorStatus: json['survivor_status'] == 1,
      joinedAt:
          json['joined_at'] != null ? DateTime.parse(json['joined_at']) : null,
      paidBuyIn: json['paid_buy_in'] == 1,
      admin: json['admin'] == 1,
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatarUrl: json['avatar_url'],
      teamSupported: json['team_supported'],
      accountBalance: json['account_balance']?.toDouble(),
      lmsAverage: json['lms_average']?.toDouble(),
      bio: json['bio'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      // NEW FIELD:
      previousPickTeamName: json['previous_pick_team_name'],
    );
  }
}
