import 'package:equatable/equatable.dart';
import 'package:panna_app/core/enums/lms_game/lms_league_button_action.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_players_entity.dart';

class LmsGameDetails extends Equatable {
  final String leagueId;
  final LeagueEntity league;
  final String? leagueBio;
  final bool leagueIsPrivate;
  final String? leagueAvatarUrl;
  final List<LmsPlayersEntity> lmsPlayers;
  final List<LeagueSurvivorRoundsEntity> leagueSurvivorRounds;
  final List<FixtureEntity> upcomingFixtures;
  final int currentGameweek;
  final SelectionsEntity? currentSelection; // Field for current user selection
  final List<SelectionsEntity> currentSelections;
  final List<SelectionsEntity> historicSelections;
  final DateTime? nextRoundStartDate;
  final int numberOfWeeksActive;
  final int memberCount;
  final double totalPot;
  final LmsLeagueButtonAction lmsButtonAction;
  final bool previousRoundStatus;
  final bool isAdmin;
  final bool hasPaidBuyIn;
  final int mutualMemberCount;
  final List<DateTime> upcomingDeadlines;
  final List<String> alreadySelectedTeams;
  final int upcomingGameweek;
  final bool survivorStatus;
  final bool isUserAMember;
  final UserProfileEntity userProfile;
  final bool gameweekLock; // New field to store the lock status
  final int playersRemaining; // New property
  final int totalPlayers; // New property
  final DateTime? currentDeadline; // New property

  const LmsGameDetails({
    required this.leagueId,
    required this.league,
    this.leagueBio,
    required this.leagueIsPrivate,
    this.leagueAvatarUrl,
    required this.lmsPlayers,
    required this.leagueSurvivorRounds,
    required this.upcomingFixtures,
    required this.currentGameweek,
    this.currentSelection, // Initialize the new field
    required this.currentSelections,
    required this.historicSelections,
    this.nextRoundStartDate,
    required this.numberOfWeeksActive,
    required this.memberCount,
    required this.totalPot,
    required this.lmsButtonAction,
    required this.previousRoundStatus,
    required this.isAdmin,
    required this.hasPaidBuyIn,
    required this.mutualMemberCount,
    required this.upcomingDeadlines,
    required this.alreadySelectedTeams,
    required this.upcomingGameweek,
    required this.survivorStatus,
    required this.isUserAMember,
    required this.userProfile,
    required this.gameweekLock,
    required this.playersRemaining,
    required this.totalPlayers,
    this.currentDeadline,
  });

  /// Creates a copy of this LmsGameDetails but with the given fields
  /// replaced with the new values.
  LmsGameDetails copyWith({
    String? leagueId,
    LeagueEntity? league,
    String? leagueBio,
    bool? leagueIsPrivate,
    String? leagueAvatarUrl,
    List<LmsPlayersEntity>? lmsPlayers,
    List<LeagueSurvivorRoundsEntity>? leagueSurvivorRounds,
    List<FixtureEntity>? upcomingFixtures,
    int? currentGameweek,
    SelectionsEntity? currentSelection,
    List<SelectionsEntity>? currentSelections,
    List<SelectionsEntity>? historicSelections,
    DateTime? nextRoundStartDate,
    int? numberOfWeeksActive,
    int? memberCount,
    double? totalPot,
    LmsLeagueButtonAction? lmsButtonAction,
    bool? previousRoundStatus,
    bool? isAdmin,
    bool? hasPaidBuyIn,
    int? mutualMemberCount,
    List<DateTime>? upcomingDeadlines,
    List<String>? alreadySelectedTeams,
    int? upcomingGameweek,
    bool? survivorStatus,
    bool? isUserAMember,
    UserProfileEntity? userProfile,
    bool? gameweekLock,
    int? playersRemaining,
    int? totalPlayers,
    DateTime? currentDeadline,
  }) {
    return LmsGameDetails(
      leagueId: leagueId ?? this.leagueId,
      league: league ?? this.league,
      leagueBio: leagueBio ?? this.leagueBio,
      leagueIsPrivate: leagueIsPrivate ?? this.leagueIsPrivate,
      leagueAvatarUrl: leagueAvatarUrl ?? this.leagueAvatarUrl,
      lmsPlayers: lmsPlayers ?? this.lmsPlayers,
      leagueSurvivorRounds: leagueSurvivorRounds ?? this.leagueSurvivorRounds,
      upcomingFixtures: upcomingFixtures ?? this.upcomingFixtures,
      currentGameweek: currentGameweek ?? this.currentGameweek,
      currentSelection: currentSelection ?? this.currentSelection,
      currentSelections: currentSelections ?? this.currentSelections,
      historicSelections: historicSelections ?? this.historicSelections,
      nextRoundStartDate: nextRoundStartDate ?? this.nextRoundStartDate,
      numberOfWeeksActive: numberOfWeeksActive ?? this.numberOfWeeksActive,
      memberCount: memberCount ?? this.memberCount,
      totalPot: totalPot ?? this.totalPot,
      lmsButtonAction: lmsButtonAction ?? this.lmsButtonAction,
      previousRoundStatus: previousRoundStatus ?? this.previousRoundStatus,
      isAdmin: isAdmin ?? this.isAdmin,
      hasPaidBuyIn: hasPaidBuyIn ?? this.hasPaidBuyIn,
      mutualMemberCount: mutualMemberCount ?? this.mutualMemberCount,
      upcomingDeadlines: upcomingDeadlines ?? this.upcomingDeadlines,
      alreadySelectedTeams: alreadySelectedTeams ?? this.alreadySelectedTeams,
      upcomingGameweek: upcomingGameweek ?? this.upcomingGameweek,
      survivorStatus: survivorStatus ?? this.survivorStatus,
      isUserAMember: isUserAMember ?? this.isUserAMember,
      userProfile: userProfile ?? this.userProfile,
      gameweekLock: gameweekLock ?? this.gameweekLock,
      playersRemaining: playersRemaining ?? this.playersRemaining,
      totalPlayers: totalPlayers ?? this.totalPlayers,
      currentDeadline: currentDeadline ?? this.currentDeadline,
    );
  }

  @override
  List<Object?> get props => [
        leagueId,
        league,
        leagueBio,
        leagueIsPrivate,
        leagueAvatarUrl,
        lmsPlayers,
        leagueSurvivorRounds,
        upcomingFixtures,
        currentGameweek,
        currentSelection,
        currentSelections,
        historicSelections,
        nextRoundStartDate,
        numberOfWeeksActive,
        memberCount,
        totalPot,
        lmsButtonAction,
        previousRoundStatus,
        isAdmin,
        hasPaidBuyIn,
        mutualMemberCount,
        upcomingDeadlines,
        alreadySelectedTeams,
        upcomingGameweek,
        survivorStatus,
        isUserAMember,
        userProfile,
        gameweekLock,
        playersRemaining,
        totalPlayers,
        currentDeadline,
      ];
}
