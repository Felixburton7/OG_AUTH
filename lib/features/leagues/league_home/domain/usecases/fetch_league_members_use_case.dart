import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/repositories/all_leagues_repository.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';

@injectable
class FetchLeagueMembersUseCase
    implements UseCase<List<LeagueMembersEntity>, String> {
  final AllLeagueRepository repository;

  FetchLeagueMembersUseCase(this.repository);

  @override
  Future<Either<Failure, List<LeagueMembersEntity>>> execute(
      String leagueId) async {
    try {
      final result = await repository.fetchLeagueMembers(leagueId);
      return result;
    } catch (e) {
      return Left(
          Failure('Failed to fetch league members')); // Handle failure case
    }
  }
}
