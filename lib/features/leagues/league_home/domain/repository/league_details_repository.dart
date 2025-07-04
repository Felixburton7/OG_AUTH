import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/league_home/data/datasource/league_details_remote_data_source.dart';

abstract class LeagueDetailsRepository {
  Future<Either<Failure, LeagueDetails>> fetchLeagueDetails(String leagueId);
  Future<Either<Failure, SelectionResponse>> makeCurrentSelection({
    required String leagueId,
    required String teamName,
  });

  // New method for leaving a league
  Future<Either<Failure, void>> leaveLeague(String leagueId);
}
