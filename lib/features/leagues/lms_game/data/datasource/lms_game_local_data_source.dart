import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';

abstract class LmsGameLocalDataSource {
  Future<void> cacheLmsGameDetails(LmsGameDetails lmsGameDetails);
  Future<LmsGameDetails?> getLastLeagueDetails(String leagueId);
}

@Injectable(as: LmsGameLocalDataSource)
class LeagueDetailsLocalDataSourceImpl implements LmsGameLocalDataSource {
  // Assuming you would implement SQLite or another local storage here later
  @override
  Future<void> cacheLmsGameDetails(LmsGameDetails lmsGameDetails) async {
    // Placeholder for caching logic
  }

  @override
  Future<LmsGameDetails?> getLastLeagueDetails(String leagueId) async {
    // Placeholder for retrieving cached data
    return null; // Returning null for now until implementation is done
  }
}
