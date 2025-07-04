import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/network/connection_checker.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/leagues/all_leagues/data/datasource/all_leagues_local_data_source.dart';
import 'package:panna_app/features/leagues/all_leagues/data/datasource/all_leagues_remote_data_source.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/repositories/all_leagues_repository.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';

@Injectable(as: AllLeagueRepository)
class AllLeaguesRepositoryImpl implements AllLeagueRepository {
  final AllLeaguesRemoteDataSource allLeaguesRemoteDataSource;
  final AllLeaguesLocalDataSource allLeaguesLocalDataSource;
  final ConnectionChecker connectionChecker;

  AllLeaguesRepositoryImpl(
    this.allLeaguesRemoteDataSource,
    this.allLeaguesLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<LeagueSummary>>> fetchUserLeagues() async {
    getIt<ConnectionChecker>;
    try {
      final isConnected = await connectionChecker.isConnected;

      // If not connected to the internet, get data from local storage
      if (!await connectionChecker.isConnected) {
        final leagueSummary =
            await allLeaguesLocalDataSource.fetchUserLeagues();
        return Right(leagueSummary);
      }

      // Otherwise, fetch from remote and cache the result locally
      final leagueSummary = await allLeaguesRemoteDataSource.fetchUserLeagues();
      await allLeaguesLocalDataSource.uploadLocalAllUserLeagues(leagueSummary);

      return Right(leagueSummary);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeagueEntity>> fetchLeagueDetails(
      String leagueId) async {
    try {
      // Fetch league details remotely
      final leagueEntity =
          await allLeaguesRemoteDataSource.fetchLeagueDetails(leagueId);
      return Right(leagueEntity);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeagueMembersEntity>>> fetchLeagueMembers(
      String leagueId) async {
    try {
      // Fetch league members remotely
      final leagueMembers =
          await allLeaguesRemoteDataSource.fetchLeagueMembers(leagueId);
      return Right(leagueMembers);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeagueSurvivorRoundsEntity>>>
      fetchLeagueSurvivorRounds(String leagueId) async {
    try {
      // Fetch league survivor rounds remotely
      final survivorRounds =
          await allLeaguesRemoteDataSource.fetchLeagueSurvivorRounds(leagueId);
      return Right(survivorRounds);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
