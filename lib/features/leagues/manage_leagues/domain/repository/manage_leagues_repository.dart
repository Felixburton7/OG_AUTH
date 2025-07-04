import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';

abstract class ManageLeaguesRepository {
  Future<void> joinLeague(String leagueId);
  Future<bool> payBuyIn(String leagueId);
  Future<LeagueDTO> createLeague(LeagueDTO league);
  Future<LeagueDTO> updateLeague(LeagueDTO league);
  Future<List<Map<String, String>>> fetchUpcomingGameWeeks(); // New method
  Future<LeagueSummary> verifyAddCode(String addCode);
  Future<void> updateLeagueDetails(LeagueDTO updatedLeague);
}
