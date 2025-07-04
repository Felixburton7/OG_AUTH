import 'package:equatable/equatable.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';

class H2hGameDetails extends Equatable {
  final String leagueId;
  final LeagueEntity league;
  final String? leagueBio;
  final bool leagueIsPrivate;
  final String? leagueAvatarUrl;
  final double buyIn;
  final List<BetOfferEntity> betOffers;
  final List<BetChallengeEntity>? betChallenges;
  final List<LeagueMembersEntity> leagueMembers;
  final List<FixtureEntity> fixtures;
  final int currentGameweekNumber; // Updated: gameweek number
  final String currentGameweekId; // New field: gameweek id (UUID as String)
  final DateTime currentDeadline;
  final String addCode;
  final String createdBy;
  final DateTime createdAt;
  final int memberCount;
  final String profileId;
  final DateTime? profileUpdatedAt;
  final DateTime? profileDateOfBirth;
  final String profileUsername;
  final String profileAvatarUrl;
  final String profileTeamSupported;
  final double profileAccountBalance;
  final String profileFirstName;
  final String profileLastName;
  final bool isAdmin;
  final int mutualMemberCount;
  final int totalPlayers;

  const H2hGameDetails({
    required this.leagueId,
    required this.league,
    this.leagueBio,
    required this.leagueIsPrivate,
    this.leagueAvatarUrl,
    required this.buyIn,
    required this.betOffers,
    this.betChallenges,
    required this.leagueMembers,
    required this.fixtures,
    required this.currentGameweekNumber,
    required this.currentGameweekId,
    required this.currentDeadline,
    required this.addCode,
    required this.createdBy,
    required this.createdAt,
    required this.memberCount,
    required this.profileId,
    this.profileUpdatedAt,
    this.profileDateOfBirth,
    required this.profileUsername,
    required this.profileAvatarUrl,
    required this.profileTeamSupported,
    required this.profileAccountBalance,
    required this.profileFirstName,
    required this.profileLastName,
    required this.isAdmin,
    required this.mutualMemberCount,
    required this.totalPlayers,
  });

  @override
  List<Object?> get props => [
        leagueId,
        league,
        leagueBio,
        leagueIsPrivate,
        leagueAvatarUrl,
        buyIn,
        betOffers,
        betChallenges,
        leagueMembers,
        fixtures,
        currentGameweekNumber,
        currentGameweekId,
        currentDeadline,
        addCode,
        createdBy,
        createdAt,
        memberCount,
        profileId,
        profileUpdatedAt,
        profileDateOfBirth,
        profileUsername,
        profileAvatarUrl,
        profileTeamSupported,
        profileAccountBalance,
        profileFirstName,
        profileLastName,
        isAdmin,
        mutualMemberCount,
        totalPlayers,
      ];
}
