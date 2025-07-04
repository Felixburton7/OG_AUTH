import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';

@injectable
class FetchUpcomingGameWeeksUseCase
    extends UseCase<List<Map<String, String>>, NoParams> {
  final ManageLeaguesRepository _manageLeaguesRepository;

  FetchUpcomingGameWeeksUseCase(this._manageLeaguesRepository);

  @override
  Future<Either<Failure, List<Map<String, String>>>> execute(
      NoParams params) async {
    try {
      final upcomingGameWeeks =
          await _manageLeaguesRepository.fetchUpcomingGameWeeks();
      return Right(upcomingGameWeeks); // Return success case
    } catch (e) {
      return Left(Failure()); // Return failure case
    }
  }
}
