import 'package:injectable/injectable.dart';
import 'package:panna_app/features/fixtures_and_standings/data/mapper/fixture_DTO.dart';
import 'package:panna_app/features/fixtures_and_standings/data/mapper/game_week_DTO.dart';
import 'package:panna_app/features/fixtures_and_standings/data/mapper/standing_DTO.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable()
class SupabaseFixturesStandingsRepository {
  final SupabaseClient _supabaseClient;

  SupabaseFixturesStandingsRepository(this._supabaseClient);

  Future<List<FixtureDTO>> fetchAllFixtures() async {
    final response = await _supabaseClient.from('fixtures').select();
    return (response as List).map((json) => FixtureDTO.fromJson(json)).toList();
  }

  // Fetch all fixtures by gameweek ID
  Future<List<FixtureDTO>> fetchFixturesByGameWeek(String gameweekId) async {
    final response = await _supabaseClient
        .from('fixtures')
        .select()
        .eq('gameweek_id', gameweekId)
        .order('start_time', ascending: true);

    return (response as List).map((json) => FixtureDTO.fromJson(json)).toList();
  }

  Stream<List<FixtureDTO>> getLiveFixturesStream(String gameweekId) {
    return _supabaseClient
        .from('fixtures')
        .stream(primaryKey: ['fixture_id'])
        .eq('gameweek_id', gameweekId)
        .order('start_time', ascending: true)
        .asyncMap((maps) async {
          List<FixtureDTO> fixtures =
              maps.map((map) => FixtureDTO.fromJson(map)).toList();
          return fixtures;
        });
  }

  // Fetch the current gameweek
  Future<GameWeekDTO> fetchCurrentGameWeek() async {
    final response = await _supabaseClient
        .from('game_weeks')
        .select()
        .eq('current_game_week', true)
        .single();

    if (response == null) {
      throw Exception('No current game week found');
    }

    return GameWeekDTO.fromJson(response);
  }

  // Fetch a specific gameweek by its number
  Future<GameWeekDTO?> fetchGameWeekByNumber(int gameweekNumber) async {
    final response = await _supabaseClient
        .from('game_weeks')
        .select()
        .eq('gameweek_number', gameweekNumber)
        .single();

    return GameWeekDTO.fromJson(response);
  }

  // Fetch all upcoming gameweeks
  Future<List<GameWeekDTO>> fetchUpcomingGameWeeks() async {
    final response = await _supabaseClient
        .from('game_weeks')
        .select()
        .gt('deadline', DateTime.now().toIso8601String())
        .order('gameweek_number', ascending: true);

    return (response as List)
        .map((json) => GameWeekDTO.fromJson(json))
        .toList();
  }

  // Fetch standings from the premier_league_standings table
  Future<List<StandingsDTO>> fetchStandings() async {
    final response = await _supabaseClient
        .from('premier_league_standings')
        .select()
        .order('points', ascending: false)
        .order('goal_difference', ascending: false);

    return (response as List)
        .map((json) => StandingsDTO.fromJson(json))
        .toList();
  }

  // Optional: Update fixture score
  Future<void> updateFixtureScore(
      String fixtureId, int homeTeamScore, int awayTeamScore) async {
    final response = await _supabaseClient.from('fixtures').update({
      'home_team_score': homeTeamScore,
      'away_team_score': awayTeamScore,
      'finished_status': true,
    }).eq('fixture_id', fixtureId);

    if (response.error != null) {
      throw Exception('Failed to update fixture score: $response');
    }
  }

  // Fetch the team name by team ID
  Future<String> fetchTeamNameById(String teamId) async {
    final response = await _supabaseClient
        .from('teams')
        .select('team_name')
        .eq('team_id', teamId)
        .maybeSingle();

    if (response == null) {
      throw Exception('No team found with team_id: $teamId');
    }

    return response['team_name'];
  }
}
