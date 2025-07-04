// lms_game_repository_impl.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/lms_game/data/datasource/lms_game_local_data_source.dart';
import 'package:panna_app/features/leagues/lms_game/data/datasource/lms_game_remote_data_source.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/repository/lms_game_repository.dart';

@Injectable(as: LmsGameRepository)
class LmsGameRepositoryImpl implements LmsGameRepository {
  final LmsGameRemoteDataSource remoteDataSource;
  final LmsGameLocalDataSource localDataSource;

  LmsGameRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<Either<Failure, LmsGameDetails>> fetchLmsGameDetails(
      String leagueId) async {
    try {
      final gameDetails = await remoteDataSource.fetchLmsGameDetails(leagueId);

      return gameDetails.fold(
        (failure) async {
          final localData =
              await localDataSource.getLastLeagueDetails(leagueId);
          if (localData != null) {
            return Right(localData);
          } else {
            return Left(Failure(
                'Failed to fetch LMS game details from both remote and local sources.'));
          }
        },
        (gameDetails) async {
          await localDataSource.cacheLmsGameDetails(gameDetails);
          return Right(gameDetails);
        },
      );
    } catch (e) {
      return Left(Failure('Failed to fetch LMS game details: $e'));
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
        (failure) => Left(Failure('Failed to make current selection')),
        (selectionResponse) => Right(selectionResponse),
      );
    } catch (e) {
      return Left(Failure('Failed to make current selection: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveLmsLeague(String leagueId) async {
    try {
      print("Leave LMS league printed in repository implementation");
      final result = await remoteDataSource.leaveLeague(leagueId);
      return result.fold(
        (failure) =>
            Left(Failure('Failed to leave the LMS league: ${failure.message}')),
        (_) => Right(()),
      );
    } catch (e) {
      return Left(Failure(
          'An unexpected error occurred while leaving the LMS league.'));
    }
  }
}
