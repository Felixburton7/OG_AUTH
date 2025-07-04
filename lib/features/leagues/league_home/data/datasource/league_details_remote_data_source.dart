import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class LeagueDetailsRemoteDataSource {
  final SupabaseClient supabase;

  LeagueDetailsRemoteDataSource(this.supabase);

  // 1) The main method to fetch league details from Supabase
  Future<Either<Failure, LeagueDetails>> fetchLeagueDetails(
      String leagueId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return Left(Failure('User is not authenticated.'));
    }

    try {
      final response = await supabase.rpc('fetch_league_details', params: {
        'p_user_id': userId,
        'p_league_id': leagueId,
      }).single();

      // Convert the raw response into a strongly-typed LeagueDetails object
      final leagueDetails = _mapToLeagueDetails(response);
      return Right(leagueDetails);
    } catch (e) {
      return Left(
          Failure('Failed to fetch league details. Please try again later.'));
    }
  }

  // 2) Map the returned JSON/Map to our LeagueDetails model
  LeagueDetails _mapToLeagueDetails(Map<String, dynamic> data) {
    // Helpers
    bool _parseBool(dynamic val) =>
        (val is bool) ? val : (val.toString().toLowerCase() == 'true');
    double _parseDouble(dynamic val) =>
        double.tryParse(val?.toString() ?? '0') ?? 0.0;

    // 1) Create the LeagueEntity
    final league = LeagueEntity(
      leagueId: data['league_id'] as String?,
      leagueTitle: data['league_title'] as String?,
      leagueBio: data['league_bio'] as String?,
      leagueIsPrivate: _parseBool(data['league_is_private']),
      leagueAvatarUrl: data['league_avatar_url'] as String?,
      buyIn: _parseDouble(data['buy_in']),
      createdAt: (data['created_at'] != null)
          ? DateTime.tryParse(data['created_at'])
          : null,
      createdBy: data['created_by'] as String?,
      addCode: data['add_code'] as String?,
    );

    // 2) Create the UserProfileEntity
    final userProfile = UserProfileEntity(
      profileId: data['profile_id'] as String?,
      updatedAt: (data['profile_updated_at'] != null)
          ? DateTime.tryParse(data['profile_updated_at'])
          : null,
      dateOfBirth: (data['profile_date_of_birth'] != null)
          ? DateTime.tryParse(data['profile_date_of_birth'])
          : null,
      username: data['profile_username'] as String?,
      avatarUrl: data['profile_avatar_url'] as String?,
      teamSupported: data['profile_team_supported'] as String?,
      accountBalance: _parseDouble(data['profile_account_balance']),
      firstName: data['profile_first_name'] as String?,
      lastName: data['profile_last_name'] as String?,
      lmsAverage: _parseDouble(data['profile_lms_average']),
      bio: data['profile_bio'] as String?,
    );

    // 3) Current selection
    final currentSelection = data['current_selection'] != null
        ? SelectionsEntity(
            selectionId: data['current_selection']['selection_id'] as String,
            userId: data['current_selection']['user_id'] as String,
            leagueId: data['league_id'] as String,
            roundId: '',
            teamId: '',
            teamName: data['current_selection']['team_name'] as String,
            gameWeekId: '',
            gameWeekNumber: data['current_selection']['gameweek_number'] ?? 0,
            selectionDate: (data['current_selection']['selection_date'] != null)
                ? DateTime.tryParse(data['current_selection']['selection_date'])
                : null,
            madeSelectionStatus:
                _parseBool(data['current_selection']['result']),
            result: _parseBool(data['current_selection']['result']),
          )
        : null;

    // 4) Current selections (for all members)
    final currentSelections = (data['current_selections'] as List<dynamic>?)
            ?.map((item) => SelectionsEntity(
                  selectionId: item['selection_id'] as String,
                  userId: item['user_id'] as String,
                  leagueId: data['league_id'] as String,
                  roundId: '',
                  teamId: '',
                  teamName: item['team_name'] as String,
                  gameWeekId: '',
                  gameWeekNumber: item['gameweek_number'] ?? 0,
                  selectionDate: (item['selection_date'] != null)
                      ? DateTime.tryParse(item['selection_date'])
                      : null,
                  madeSelectionStatus: _parseBool(item['result']),
                  result: _parseBool(item['result']),
                ))
            .toList() ??
        [];

    // 5) Historic selections
    final historicSelections = (data['historic_selections'] as List<dynamic>?)
            ?.expand<SelectionsEntity>((round) {
          final roundId = round['round_id'] as String? ?? '';
          final gameweeks = (round['gameweeks'] as List<dynamic>?)
              ?.expand<SelectionsEntity>((gw) =>
                  (gw['selections'] as List<dynamic>?)
                      ?.map((sel) => SelectionsEntity(
                            selectionId: sel['selection_id'] as String,
                            userId: sel['user_id'] as String,
                            leagueId: data['league_id'] as String,
                            roundId: roundId,
                            teamId: '',
                            teamName: sel['team_name'] as String,
                            gameWeekId: '',
                            gameWeekNumber: sel['gameweek_number'] ?? 0,
                            selectionDate: (sel['selection_date'] != null)
                                ? DateTime.tryParse(sel['selection_date'])
                                : null,
                            madeSelectionStatus: _parseBool(sel['result']),
                            result: _parseBool(sel['result']),
                          ))
                      .toList() ??
                  [])
              .toList();
          return gameweeks ?? <SelectionsEntity>[];
        }).toList() ??
        [];

    // 6) LeagueMembers
    final leagueMembers = (data['league_members'] as List<dynamic>?)?.map((lm) {
          // parse joined_at if it's a string
          DateTime? joinedAt;
          if (lm['joined_at'] is String) {
            joinedAt = DateTime.tryParse(lm['joined_at']);
          } else if (lm['joined_at'] is DateTime) {
            joinedAt = lm['joined_at'];
          }
          return LeagueMembersEntity(
            leagueMemberId: lm['league_member_id'] as String?,
            profileId: lm['profile_id'] as String?,
            survivorStatus: lm['survivor_status'] as bool? ?? false,
            previousPickTeamName: lm['previous_pick_team_name'] as String?,
            joinedAt: joinedAt ?? DateTime.now(),
            paidBuyIn: lm['paid_buy_in'] as bool? ?? false,
            admin: lm['admin'] as bool? ?? false,
            username: lm['profile_details']['username'] as String?,
            firstName: lm['profile_details']['first_name'] as String?,
            lastName: lm['profile_details']['last_name'] as String?,
            avatarUrl: lm['profile_details']['avatar_url'] as String?,
            teamSupported: lm['profile_details']['team_supported'] as String?,
            accountBalance: (lm['profile_details']['account_balance'] != null)
                ? double.tryParse(
                    lm['profile_details']['account_balance'].toString())
                : null,
            lmsAverage: 0.0, // parse if needed
            bio: lm['profile_details']['bio'] as String?,
            dateOfBirth: (lm['profile_details']['date_of_birth'] != null)
                ? DateTime.tryParse(lm['profile_details']['date_of_birth'])
                : null,
          );
        }).toList() ??
        [];

    // 7) current_fixtures
    final currentFixtures = (data['current_fixtures'] as List<dynamic>?)
            ?.map((fix) => FixtureEntity(
                  fixtureId: fix['fixture_id'] as String?,
                  homeTeamId: '',
                  awayTeamId: '',
                  homeTeamScore: 0,
                  awayTeamScore: 0,
                  homeTeamName: fix['home_team_name'] as String?,
                  awayTeamName: fix['away_team_name'] as String?,
                  startTime: fix['start_time'] != null
                      ? DateTime.tryParse(fix['start_time']) ?? DateTime.now()
                      : DateTime.now(),
                  endTime: fix['end_time'] != null
                      ? DateTime.tryParse(fix['end_time'])
                      : null,
                  homeTeamWin: _parseBool(fix['home_team_win']),
                  awayTeamWin: _parseBool(fix['away_team_win']),
                  delayedStatus: _parseBool(fix['delayed_status']),
                ))
            .toList() ??
        [];

    // 8) Map everything into LeagueDetails
    return LeagueDetails(
      leagueId: data['league_id'] as String,
      league: league,
      leagueBio: data['league_bio'] as String?,
      leagueIsPrivate: _parseBool(data['league_is_private']),
      leagueAvatarUrl: data['league_avatar_url'] as String?,
      leagueMembers: leagueMembers,
      leagueSurvivorRounds: _buildSurvivorRounds(data),
      upcomingFixtures:
          currentFixtures, // Assigned currentFixtures to upcomingFixtures
      currentGameweek: data['current_gameweek'] as int? ?? 0,
      currentSelection: currentSelection,
      currentSelections: currentSelections,
      historicSelections: historicSelections,
      nextRoundStartDate: (data['next_round_start_date'] != null)
          ? DateTime.tryParse(data['next_round_start_date'].toString())
          : null,
      numberOfWeeksActive: data['number_of_weeks_active'] as int? ?? 0,
      memberCount: data['member_count'] as int? ?? 0,
      totalPot: _parseDouble(data['total_pot']),
      buttonAction: LeagueButtonAction.none, // or your own logic
      previousRoundStatus: false,
      isAdmin: _parseBool(data['is_admin']),
      hasPaidBuyIn: _parseBool(data['has_paid_buy_in']),
      mutualMemberCount: data['mutual_member_count'] as int? ?? 0,
      // Renamed deadlines: "current_deadlines"
      // upcomingDeadlines: (data['current_deadlines'] as List<dynamic>?)
      //         ?.map((deadline) =>
      //             DateTime.tryParse(deadline.toString()) ?? DateTime.now())
      //         .toList() ??
      //     [], // Commented out

      currentDeadline: data['current_deadline'] != null
          ? DateTime.tryParse(data['current_deadline'].toString())
          : null, // Added new field

      alreadySelectedTeams: (data['already_selected_teams'] as List<dynamic>?)
              ?.map((team) => team.toString())
              .toList() ??
          [],
      upcomingGameweek: data['upcoming_gameweek'] as int? ?? 0,
      survivorStatus: data['survivor_status'] as bool? ?? false,
      isUserAMember: _parseBool(data['user_is_member']),
      userProfile: userProfile,
      // new lock field
      gameweekLock: _parseBool(data['current_gameweek_lock']),
    );
  }

  /// Helper function to build the list of LeagueSurvivorRoundsEntity fully
  List<LeagueSurvivorRoundsEntity> _buildSurvivorRounds(
      Map<String, dynamic> data) {
    final rawRounds = data['historic_selections'] as List<dynamic>? ?? [];
    bool _parseBool(dynamic val) =>
        (val is bool) ? val : (val.toString().toLowerCase() == 'true');

    return rawRounds.map((rd) {
      final gameweeks = (rd['gameweeks'] as List<dynamic>?)?.map((gw) {
        final gwSelections = (gw['selections'] as List<dynamic>?)
                ?.map((sel) => SelectionsEntity(
                      selectionId: sel['selection_id'] as String,
                      userId: sel['user_id'] as String,
                      leagueId: data['league_id'] as String,
                      roundId: rd['round_id'] as String? ?? '',
                      teamId: '',
                      teamName: sel['team_name'] as String,
                      gameWeekId: '',
                      gameWeekNumber: sel['gameweek_number'] ?? 0,
                      selectionDate: (sel['selection_date'] != null)
                          ? DateTime.tryParse(sel['selection_date'])
                          : null,
                      madeSelectionStatus: _parseBool(sel['result']),
                      result: _parseBool(sel['result']),
                    ))
                .toList() ??
            [];
        return LeagueSurvivorRoundsEntityGameWeek(
          gameWeekNumber: gw['gameweek_number'] ?? 0,
          selections: gwSelections,
        );
      }).toList();

      return LeagueSurvivorRoundsEntity(
        roundId: rd['round_id'] as String?,
        roundNumber: rd['round_number'] as int? ?? 0,
        survivorCount: rd['survivor_count'] as int? ?? 0,
        potTotal: double.tryParse(rd['pot_total']?.toString() ?? '0') ?? 0.0,
        isActiveStatus: rd['is_active_status'] as bool? ?? false,
        numberOfWeeksActive: rd['number_of_weeks_active'] as int? ?? 0,
        gameWeeks: gameweeks,
        winnerLeagueMemberIds:
            (rd['winner_league_member_ids'] as List<dynamic>?)
                ?.map((id) => id.toString())
                .toList(),
        survivorRoundStartDate: rd['survivor_round_start_date']?.toString(),
        createdAt: (rd['created_at'] != null)
            ? DateTime.tryParse(rd['created_at'].toString())
            : null,
      );
    }).toList();
  }

  bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  bool _parseBoolforLeagueIsPrivate(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() != 'false';
    return true;
  }

  @override
  Future<Either<Failure, SelectionResponse>> makeCurrentSelection({
    required String leagueId,
    required String teamName,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return Left(Failure('User is not authenticated.'));
      }

      final response = await supabase.rpc(
        'make_current_selection', // Updated name
        params: {
          'p_user_id': userId,
          'p_league_id': leagueId,
          'p_team_name': teamName,
        },
      ).single();

      if (response is Map<String, dynamic>) {
        final message = response['message'] ?? 'Unknown error occurred.';
        if (response['status'] == 'error') {
          return Left(Failure(message));
        }
        return Right(SelectionResponse(message: message));
      } else {
        return Left(Failure('Unexpected response type.'));
      }
    } catch (e) {
      return Left(Failure('Failed to make current selection: $e'));
    }
  }

  Future<Either<Failure, void>> leaveLeague(String leagueId) async {
    try {
      print('Remote datasource: Attempting to leave league');
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        print('Remote datasource: User not authenticated');
        return Left(Failure('User is not authenticated.'));
      }

      print('Remote datasource: League ID: $leagueId');
      print('Remote datasource: User ID: $userId');

      // Execute the DELETE operation
      await supabase
          .from('league_members')
          .delete()
          .match({'league_id': leagueId, 'profile_id': userId});

      print('Remote datasource: Successfully left the league');
      return Right(null);
    } catch (e) {
      print('Remote datasource: Exception - $e');
      return Left(
          Failure('Failed to leave the league. Please try again later.'));
    }
  }
}

class SelectionResponse {
  final String message;

  SelectionResponse({required this.message});
}
