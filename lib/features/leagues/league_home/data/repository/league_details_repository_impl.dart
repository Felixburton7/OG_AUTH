// league_details_repository_impl.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/league_home/data/datasource/league_details_local_data_source.dart';
import 'package:panna_app/features/leagues/league_home/data/datasource/league_details_remote_data_source.dart';
import 'package:panna_app/features/leagues/league_home/domain/repository/league_details_repository.dart';

@Injectable(as: LeagueDetailsRepository)
class LeagueDetailsRepositoryImpl implements LeagueDetailsRepository {
  final LeagueDetailsRemoteDataSource remoteDataSource;
  final LeagueDetailsLocalDataSource localDataSource;

  LeagueDetailsRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<Either<Failure, LeagueDetails>> fetchLeagueDetails(
      String leagueId) async {
    try {
      final leagueDetails = await remoteDataSource.fetchLeagueDetails(leagueId);

      return leagueDetails.fold(
        (failure) async {
          final localData =
              await localDataSource.getLastLeagueDetails(leagueId);
          if (localData != null) {
            return Right(localData);
          } else {
            return Left(Failure(
                'Failed to fetch league details from both remote and local.'));
          }
        },
        (leagueDetails) async {
          await localDataSource.cacheLeagueDetails(leagueDetails);
          return Right(leagueDetails);
        },
      );
    } catch (e) {
      return Left(Failure('Failed to fetch league details: $e'));
    }
  }

  @override
  Future<Either<Failure, SelectionResponse>> makeCurrentSelection({
    required String leagueId,
    required String teamName,
  }) async {
    try {
      final response = await remoteDataSource.makeCurrentSelection(
        leagueId: leagueId,
        teamName: teamName,
      );
      return response.fold(
        (failure) => Left(Failure('Failed to make upcoming selection')),
        (selectionResponse) => Right(selectionResponse),
      );
    } catch (e) {
      return Left(Failure('Failed to make upcoming selection: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveLeague(String leagueId) async {
    try {
      print("Levae league printed impl repository");
      final result = await remoteDataSource.leaveLeague(leagueId);
      return result.fold(
        (failure) =>
            Left(Failure('Failed to leave the league: ${failure.message}')),
        (_) => Right(()),
      );
    } catch (e) {
      return Left(
          Failure('An unexpected error occurred while leaving the league.'));
    }
  }
}
