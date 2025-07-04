import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/repository/h2h_repository.dart';

@injectable
class FetchH2hGameDetailsUseCase implements UseCase<H2hGameDetails, String> {
  final H2hGameRepository repository;

  FetchH2hGameDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, H2hGameDetails>> execute(String leagueId) async {
    return await repository.fetchH2hGameDetails(leagueId);
  }
}
