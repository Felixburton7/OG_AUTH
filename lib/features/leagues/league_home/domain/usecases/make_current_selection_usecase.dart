import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/leagues/league_home/data/datasource/league_details_remote_data_source.dart';
import 'package:panna_app/features/leagues/league_home/domain/repository/league_details_repository.dart';

@injectable
class MakeCurrentSelectionUseCase
    implements UseCase<SelectionResponse, MakeCurrentSelectionParams> {
  final LeagueDetailsRepository repository;

  MakeCurrentSelectionUseCase(this.repository);

  @override
  Future<Either<Failure, SelectionResponse>> execute(
      MakeCurrentSelectionParams params) async {
    return await repository.makeCurrentSelection(
      leagueId: params.leagueId,
      teamName: params.teamName,
    );
  }
}

class MakeCurrentSelectionParams {
  final String leagueId;
  final String teamName;

  MakeCurrentSelectionParams({
    required this.leagueId,
    required this.teamName,
  });
}
