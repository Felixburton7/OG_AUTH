import 'package:injectable/injectable.dart';
import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/usecases/fetch_all_league_avatars_usecase.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_players_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class AllLeaguesRemoteDataSource {
  AllLeaguesRemoteDataSource(this.fetchLeagueAvatarUrlUseCase);

  final SupabaseClient supabase = Supabase.instance.client;
  final FetchLeagueAvatarUrlUseCase fetchLeagueAvatarUrlUseCase;

  /// Fetch only the data needed:
  /// - league info (title, bio, avatar)
  /// - member_count
  /// - user membership (admin / joined_at, etc.)
  /// - if league is public or private
  /// - buy_in, created_by
  /// - firstSurvivorRoundStartDate if needed
  Future<List<LeagueSummary>> fetchUserLeagues() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      // Call the updated Postgres function
      final supabaseResponse = await supabase
          .rpc('fetch_league_summaries', params: {'p_user_id': userId});

      // Convert result to a List
      final dataList = supabaseResponse as List;

      // Process each league record
      final leaguesSummary = await Future.wait(dataList.map((json) async {
        // 1. Attempt to retrieve / fill avatarUrl
        String? avatarUrl = json['league_avatar_url'] as String?;
        if (avatarUrl == null || avatarUrl.isEmpty) {
          // Fallback to your avatar usecase
          avatarUrl = await fetchLeagueAvatarUrlUseCase
              .execute(json['league_id'] as String);
        }

        // 2. Build league entity
        final league = LeagueEntity(
          leagueId: json['league_id'] as String?,
          leagueTitle: json['league_title'] as String?,
          leagueBio: json['league_bio'] as String?,
          leagueIsPrivate: json['league_is_private'] as bool,
          leagueAvatarUrl: avatarUrl,
          buyIn: (json['buy_in'] as num?)?.toDouble(),
          createdBy: json['created_by'] as String?,
          firstSurvivorRoundStartDate:
              json['first_survivor_round_start_date'] != null
                  ? DateTime.tryParse(
                          json['first_survivor_round_start_date'] as String)
                      ?.toIso8601String()
                  : null,
        );

        // 3. Check membership JSON
        final leagueMemberDetailsJson =
            json['league_member_details'] as Map<String, dynamic>?;
        LeagueMembersEntity? userLeagueMemberDetails;
        if (leagueMemberDetailsJson != null) {
          userLeagueMemberDetails = LeagueMembersEntity(
            leagueMemberId:
                leagueMemberDetailsJson['league_member_id'] as String?,
            profileId: leagueMemberDetailsJson['profile_id'] as String?,
            admin: (leagueMemberDetailsJson['admin'] == 'true' ||
                leagueMemberDetailsJson['admin'] == true),
            joinedAt: leagueMemberDetailsJson['joined_at'] != null
                ? DateTime.tryParse(
                    leagueMemberDetailsJson['joined_at'] as String)
                : null,
            // Additional fields if you prefer:
            leagueId: json['league_id'] as String?,
            // or store them in the JSON as well
          );
        }
        final bool activeLeague = json['active_league'] as bool? ?? false;

        // 4. Build the LeagueSummary
        return LeagueSummary(
          league: league,
          activeLeague: activeLeague, // <-- Pass the computed value

          isUserAMember: (json['is_user_a_member'] as bool?) ?? false,
          memberCount: (json['league_member_count'] as int?) ?? 0,
          leagueMemberDetails: userLeagueMemberDetails,
          numberOfWeeksActive: null, // Not used here unless you add it
          nextRoundStartDate: null, // Similarly if you omit round info
          currentRoundStatus: false, // Omit or use your logic
          mutualMemberCount: null, // If not needed
          currentRound: null,
          totalPot: 0.0, // If not using pot
          buttonAction: LeagueButtonAction.none,
        );
      }).toList());

      return leaguesSummary;
    } catch (error) {
      throw Exception('Error fetching league summaries: $error');
    }
  }

  /// If you only need league basic details (title, bio, avatar, etc.):
  /// This can remain as-is, or you can fetch from the same function again
  /// if that’s simpler.
  Future<LeagueEntity> fetchLeagueDetails(String leagueId) async {
    try {
      final response = await supabase
          .from('leagues')
          .select()
          .eq('league_id', leagueId)
          .single();

      // Attempt to retrieve the league's avatar URL
      final avatarUrl = await fetchLeagueAvatarUrlUseCase.execute(leagueId);

      return LeagueDTO.fromJson(response)
          .copyWith(leagueAvatarUrl: avatarUrl)
          .toEntity();
    } catch (error) {
      throw Exception('Error fetching league details: $error');
    }
  }

  /// If you still keep survivor rounds somewhere else:
  Future<List<LeagueSurvivorRoundsEntity>> fetchLeagueSurvivorRounds(
      String leagueId) async {
    // Optional if you need round info from another table
    throw UnimplementedError();
  }

  /// If you need to specifically fetch all league members from `league_members`
  Future<List<LeagueMembersEntity>> fetchLeagueMembers(String leagueId) async {
    try {
      final response = await supabase
          .from('league_members')
          .select()
          .eq('league_id', leagueId);

      final resultList = response as List;
      return resultList
          .map((json) => LeagueMembersEntity.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Error fetching league members: $error');
    }
  }
}
