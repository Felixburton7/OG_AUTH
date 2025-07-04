import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/league_home/domain/repository/league_details_repository.dart';

@injectable
class FetchLeagueDetailsUseCase implements UseCase<LeagueDetails, String> {
  final LeagueDetailsRepository repository;

  FetchLeagueDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, LeagueDetails>> execute(String leagueId) async {
    return await repository.fetchLeagueDetails(leagueId);
  }
}
