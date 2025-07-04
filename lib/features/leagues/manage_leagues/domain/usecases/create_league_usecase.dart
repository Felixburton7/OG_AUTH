import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';

@injectable
class CreateLeagueUseCase extends UseCase<LeagueDTO, LeagueDTO> {
  final ManageLeaguesRepository _manageLeaguesRepository;

  CreateLeagueUseCase(this._manageLeaguesRepository);

  @override
  Future<Either<Failure, LeagueDTO>> execute(LeagueDTO league) async {
    try {
      final createdLeague = await _manageLeaguesRepository.createLeague(league);
      return Right(createdLeague); // Return success case
    } catch (e) {
      return Left(Failure()); // Return failure case
    }
  }
}
