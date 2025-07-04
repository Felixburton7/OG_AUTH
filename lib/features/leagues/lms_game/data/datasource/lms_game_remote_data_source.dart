// import 'package:fpdart/fpdart.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/enums/lms_game/lms_league_button_action.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_players_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class LmsGameRemoteDataSource {
  final SupabaseClient supabase;

  LmsGameRemoteDataSource(this.supabase);

  /// 1) Fetch LMS game details from Supabase
  ///
  /// This uses your `fetch_lms_game_details` RPC, which now returns
  /// an array called `lms_players` (instead of `league_members`) as well
  /// as all other fields you requested. Everything else remains the same.
  Future<Either<Failure, LmsGameDetails>> fetchLmsGameDetails(
    String leagueId,
  ) async {
    final userId = supabase.auth.currentUser?.id; // NOT TESTABEL 
    if (userId == null) {
      return Left(Failure('User is not authenticated.'));
    }

    try {
      // Call the Postgres function
      final response = await supabase.rpc(
        'fetch_lms_game_details',
        params: {
          'p_user_id': userId,
          'p_league_id': leagueId,
        },
      ).single();

      // Convert raw response to strongly-typed LmsGameDetails
      final lmsGameDetails = _mapToLmsGameDetails(response);
      return Right(lmsGameDetails);
    } catch (e) {
      return Left(Failure(
        'Failed to fetch LMS game details. Please try again later.',
      ));
    }
  }

  /// 2) Convert the JSON/Map returned by Postgres into our LmsGameDetails model
  LmsGameDetails _mapToLmsGameDetails(Map<String, dynamic> data) {
    // Helper methods
    bool _parseBool(dynamic val) =>
        val is bool ? val : (val.toString().toLowerCase() == 'true');

    double _parseDouble(dynamic val) =>
        double.tryParse(val?.toString() ?? '0') ?? 0.0;

    // 2a) Build a LeagueEntity
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

    // 2b) Build the user’s own profile entity
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

    // 2c) Current user’s selection for the current gameweek
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
                ? DateTime.tryParse(
                    data['current_selection']['selection_date'],
                  )
                : null,
            madeSelectionStatus:
                _parseBool(data['current_selection']['result']),
            result: _parseBool(data['current_selection']['result']),
          )
        : null;

    // 2d) Current selections (for ALL members) for current gameweek
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
                  result: item['result'] != null
                      ? _parseBool(item['result'])
                      : null,
                ))
            .toList() ??
        [];

    // 2e) Historic selections
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
                            result: sel['result'] != null
                                ? _parseBool(sel['result'])
                                : null,
                          ))
                      .toList() ??
                  [])
              .toList();
          return gameweeks ?? [];
        }).toList() ??
        [];

    // 2f) lms_players array
    final lmsPlayers = (data['lms_players'] as List<dynamic>?)?.map((lmsp) {
          DateTime? joinedAt;
          if (lmsp['joined_at'] is String) {
            joinedAt = DateTime.tryParse(lmsp['joined_at']);
          } else if (lmsp['joined_at'] is DateTime) {
            joinedAt = lmsp['joined_at'];
          }
          return LmsPlayersEntity(
            playerId: lmsp['player_id'] as String?,
            leagueMemberId: lmsp['league_member_id'] as String?,
            profileId: lmsp['profile_id'] as String?,
            leagueId: data['league_id'] as String?,
            survivorStatus: lmsp['survivor_status'] as bool? ?? false,
            joinedAt: joinedAt ?? DateTime.now(),
            paidBuyIn: lmsp['paid_buy_in'] as bool? ?? false,
            admin: lmsp['admin'] as bool? ?? false,
            username: lmsp['profile_details']['username'] as String?,
            firstName: lmsp['profile_details']['first_name'] as String?,
            lastName: lmsp['profile_details']['last_name'] as String?,
            avatarUrl: lmsp['profile_details']['avatar_url'] as String?,
            teamSupported: lmsp['profile_details']['team_supported'] as String?,
            accountBalance: (lmsp['profile_details']['account_balance'] != null)
                ? double.tryParse(
                    lmsp['profile_details']['account_balance'].toString(),
                  )
                : 0.0,
            lmsAverage: 0.0, // parse if needed
            bio: lmsp['profile_details']['bio'] as String?,
            dateOfBirth: (lmsp['profile_details']['date_of_birth'] != null)
                ? DateTime.tryParse(
                    lmsp['profile_details']['date_of_birth'],
                  )
                : null,
          );
        }).toList() ??
        [];

    // 2g) Current fixtures
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

    // 2h) Build and return LmsGameDetails
    return LmsGameDetails(
      leagueId: data['league_id'] as String,
      league: league,
      leagueBio: data['league_bio'] as String?,
      leagueIsPrivate: _parseBool(data['league_is_private']),
      leagueAvatarUrl: data['league_avatar_url'] as String?,
      lmsPlayers: lmsPlayers,
      leagueSurvivorRounds: _buildSurvivorRounds(data),
      upcomingFixtures: currentFixtures,
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
      lmsButtonAction: LmsLeagueButtonAction.none, // Updated later by the BLoC
      previousRoundStatus: false,
      isAdmin: _parseBool(data['is_admin']),
      hasPaidBuyIn: _parseBool(data['has_paid_buy_in']),
      mutualMemberCount: data['mutual_member_count'] as int? ?? 0,
      upcomingDeadlines: (data['current_deadlines'] as List<dynamic>?)
              ?.map(
                (deadline) =>
                    DateTime.tryParse(deadline.toString()) ?? DateTime.now(),
              )
              .toList() ??
          [],
      alreadySelectedTeams: (data['already_selected_teams'] as List<dynamic>?)
              ?.map((t) => t.toString())
              .toList() ??
          [],
      upcomingGameweek: data['upcoming_gameweek'] as int? ?? 0,
      survivorStatus: data['survivor_status'] as bool? ?? false,
      isUserAMember: _parseBool(data['user_is_member']),
      userProfile: userProfile,
      gameweekLock: _parseBool(data['current_gameweek_lock']),
      playersRemaining: (data['players_remaining'] as int?) ?? 0,
      totalPlayers: (data['total_players'] as int?) ?? 0,
      // Map the new property using the value from current_deadline from Postgres.
      currentDeadline: data['current_deadline'] != null
          ? DateTime.tryParse(data['current_deadline'].toString())
          : null,
    );
  }

  /// Helper function to parse the "historic_selections" into SurvivorRounds
  List<LeagueSurvivorRoundsEntity> _buildSurvivorRounds(
    Map<String, dynamic> data,
  ) {
    final rawRounds = data['historic_selections'] as List<dynamic>? ?? [];
    bool _parseBool(dynamic val) =>
        val is bool ? val : (val.toString().toLowerCase() == 'true');

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

  /// Make a selection for the current gameweek
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
        'make_current_selection',
        params: {
          'p_user_id': userId,
          'p_league_id': leagueId,
          'p_team_name': teamName,
        },
      ).single();

      if (response is Map<String, dynamic>) {
        final status = response['status'] as String?;
        final message = response['message'] ?? 'Unknown error occurred.';
        if (status == 'error') {
          return Left(Failure(message));
        }

        
        return Right(SelectionResponse(message: message));
      } else {
        return Left(Failure('Unexpected response type from RPC.'));
      }
    } catch (e) {
      return Left(Failure('Failed to make current selection: $e'));
    }
  }

  /// Leave the LMS league
  Future<Either<Failure, void>> leaveLeague(String leagueId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return Left(Failure('User is not authenticated.'));
      }

      // Delete from lms_players
      await supabase
          .from('lms_players')
          .delete()
          .match({'league_id': leagueId, 'profile_id': userId});

      return Right(null);
    } catch (e) {
      return Left(
          Failure('Failed to leave the league. Please try again later.'));
    }
  }
}

/// Simple container for RPC response
class SelectionResponse {
  final String message;
  SelectionResponse({required this.message});
}
