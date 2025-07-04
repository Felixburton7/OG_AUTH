import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/repositories/all_leagues_repository.dart';

@injectable
class FetchUserLeaguesUseCase
    implements UseCase<List<LeagueSummary>, NoParams> {
  final AllLeagueRepository repository;

  FetchUserLeaguesUseCase(this.repository);

  @override
  Future<Either<Failure, List<LeagueSummary>>> execute(NoParams params) {
    return repository.fetchUserLeagues();
  }
}
