import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/lms_game/data/datasource/lms_game_remote_data_source.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';

abstract class LmsGameRepository {
  Future<Either<Failure, LmsGameDetails>> fetchLmsGameDetails(String leagueId);
  Future<Either<Failure, SelectionResponse>> makeCurrentSelection({
    required String leagueId,
    required String teamName,
  });

  // New method for leaving a league
  Future<Either<Failure, void>> leaveLmsLeague(String leagueId);
}
