import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';

import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';

class LeagueSummary {
  final LeagueEntity league;
  final bool activeLeague; // <-- New property
  final int? numberOfWeeksActive;
  final DateTime? nextRoundStartDate;
  final bool isUserAMember;
  final bool currentRoundStatus;
  final int memberCount;
  final double totalPot;
  final int? mutualMemberCount;
  final int? currentRound;
  final LeagueMembersEntity? leagueMemberDetails;
  final LeagueButtonAction buttonAction;

  LeagueSummary({
    required this.league,
    required this.activeLeague, // <-- Include in constructor
    required this.numberOfWeeksActive,
    required this.nextRoundStartDate,
    required this.isUserAMember,
    required this.currentRoundStatus,
    required this.memberCount,
    required this.totalPot,
    this.mutualMemberCount,
    this.currentRound,
    this.leagueMemberDetails,
    required this.buttonAction,
  });

  Map<String, dynamic> toJson() {
    return {
      'league': league.toJson(),
      'active_league': activeLeague, // <-- Add to JSON
      'number_of_weeks_active': numberOfWeeksActive,
      'next_round_start_date': nextRoundStartDate?.toIso8601String(),
      'is_user_a_member': isUserAMember ? 1 : 0,
      'current_round_status': currentRoundStatus ? 1 : 0,
      'member_count': memberCount,
      'total_pot': totalPot,
      'mutual_member_count': mutualMemberCount,
      'current_round': currentRound,
      'league_member_details': leagueMemberDetails?.toJson(),
      'button_action': buttonAction.toString(),
    };
  }

  static LeagueSummary fromJson(Map<String, dynamic> json) {
    return LeagueSummary(
      league: LeagueEntity.fromJson(json['league']),
      activeLeague:
          json['active_league'] as bool? ?? false, // <-- Read from JSON
      numberOfWeeksActive: json['number_of_weeks_active'],
      nextRoundStartDate: json['next_round_start_date'] != null
          ? DateTime.parse(json['next_round_start_date'])
          : null,
      isUserAMember: json['is_user_a_member'] == 1,
      currentRoundStatus: json['current_round_status'] == 1,
      memberCount: json['member_count'],
      totalPot: (json['total_pot'] as num).toDouble(),
      mutualMemberCount: json['mutual_member_count'],
      currentRound: json['current_round'],
      leagueMemberDetails: json['league_member_details'] != null
          ? LeagueMembersEntity.fromJson(json['league_member_details'])
          : null,
      buttonAction: LeagueButtonAction.values.firstWhere(
        (e) => e.toString() == json['button_action'],
        orElse: () => LeagueButtonAction.none,
      ),
    );
  }

  LeagueSummary copyWith({
    LeagueEntity? league,
    bool? activeLeague, // <-- Add copyWith parameter
    int? numberOfWeeksActive,
    DateTime? nextRoundStartDate,
    bool? isUserAMember,
    bool? currentRoundStatus,
    int? memberCount,
    double? totalPot,
    int? mutualMemberCount,
    int? currentRound,
    LeagueMembersEntity? leagueMemberDetails,
    LeagueButtonAction? buttonAction,
  }) {
    return LeagueSummary(
      league: league ?? this.league,
      activeLeague: activeLeague ?? this.activeLeague,
      numberOfWeeksActive: numberOfWeeksActive ?? this.numberOfWeeksActive,
      nextRoundStartDate: nextRoundStartDate ?? this.nextRoundStartDate,
      isUserAMember: isUserAMember ?? this.isUserAMember,
      currentRoundStatus: currentRoundStatus ?? this.currentRoundStatus,
      memberCount: memberCount ?? this.memberCount,
      totalPot: totalPot ?? this.totalPot,
      mutualMemberCount: mutualMemberCount ?? this.mutualMemberCount,
      currentRound: currentRound ?? this.currentRound,
      leagueMemberDetails: leagueMemberDetails ?? this.leagueMemberDetails,
      buttonAction: buttonAction ?? this.buttonAction,
    );
  }
}
