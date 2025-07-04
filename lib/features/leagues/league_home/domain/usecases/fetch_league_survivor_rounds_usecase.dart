import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/repositories/all_leagues_repository.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';

@injectable
class FetchLeagueSurvivorRoundsUseCase
    implements UseCase<List<LeagueSurvivorRoundsEntity>, String> {
  final AllLeagueRepository repository;

  FetchLeagueSurvivorRoundsUseCase(this.repository);

  @override
  Future<Either<Failure, List<LeagueSurvivorRoundsEntity>>> execute(
      String leagueId) async {
    try {
      final result = await repository.fetchLeagueSurvivorRounds(leagueId);
      return result; // Repository will return Either<Failure, List<LeagueSurvivorRoundsEntity>>
    } catch (e) {
      return Left(Failure('Failed to fetch survivor rounds'));
    }
  }
}
