import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';

@injectable
class UpdateLeagueUseCase {
  final ManageLeaguesRepository _leagueRepository;

  UpdateLeagueUseCase(this._leagueRepository);

  Future<Either<Failure, LeagueDTO>> execute(LeagueDTO league) async {
    try {
      final updatedLeague = await _leagueRepository.updateLeague(league);
      return Right(updatedLeague); // Success case
    } catch (error) {
      return Left(Failure(error.toString())); // Failure case
    }
  }
}
