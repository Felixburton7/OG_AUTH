import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';

abstract class LeagueDetailsLocalDataSource {
  Future<void> cacheLeagueDetails(LeagueDetails leagueDetails);
  Future<LeagueDetails?> getLastLeagueDetails(String leagueId);
}

@Injectable(as: LeagueDetailsLocalDataSource)
class LeagueDetailsLocalDataSourceImpl implements LeagueDetailsLocalDataSource {
  // Assuming you would implement SQLite or another local storage here later
  @override
  Future<void> cacheLeagueDetails(LeagueDetails leagueDetails) async {
    // Placeholder for caching logic
  }

  @override
  Future<LeagueDetails?> getLastLeagueDetails(String leagueId) async {
    // Placeholder for retrieving cached data
    return null; // Returning null for now until implementation is done
  }
}
