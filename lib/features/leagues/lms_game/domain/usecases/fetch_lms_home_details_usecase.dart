import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/league_home/domain/repository/league_details_repository.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/repository/lms_game_repository.dart';

@injectable
class FetchLmsGameDetailsUseCase implements UseCase<LmsGameDetails, String> {
  final LmsGameRepository repository;

  FetchLmsGameDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, LmsGameDetails>> execute(String leagueId) async {
    return await repository.fetchLmsGameDetails(leagueId);
  }
}
