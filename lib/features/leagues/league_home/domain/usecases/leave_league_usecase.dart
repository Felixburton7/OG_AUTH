// leave_league_params.dart

import 'package:equatable/equatable.dart';
import 'package:panna_app/core/value_objects/create_league/create_league_title_value_object.dart';
// leave_league_usecase.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/leagues/league_home/domain/repository/league_details_repository.dart';

@injectable
class LeaveLeagueUseCase implements UseCase<void, LeaveLeagueParams> {
  final LeagueDetailsRepository repository;

  LeaveLeagueUseCase(this.repository);

  @override
  Future<Either<Failure, void>> execute(LeaveLeagueParams params) async {
    print('leaving ${params.leagueId}');
    return await repository.leaveLeague(params.leagueId);
  }
}

class LeaveLeagueParams extends Equatable {
  final String leagueId;

  const LeaveLeagueParams({required this.leagueId});

  @override
  List<Object?> get props => [leagueId];
}
