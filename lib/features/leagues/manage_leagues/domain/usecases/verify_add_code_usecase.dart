import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';

@injectable
class VerifyAddCodeUsecase extends UseCase<LeagueSummary, String> {
  final ManageLeaguesRepository repository;

  VerifyAddCodeUsecase(this.repository);

  @override
  Future<Either<Failure, LeagueSummary>> execute(String addCode) async {
    try {
      final result = await repository.verifyAddCode(addCode);
      return Right(result);
    } catch (error) {
      return Left(Failure(error.toString()));
    }
  }
}
