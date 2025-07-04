import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';

abstract interface class AllLeagueRepository {
  Future<Either<Failure, LeagueEntity>> fetchLeagueDetails(String leagueId);
  Future<Either<Failure, List<LeagueMembersEntity>>> fetchLeagueMembers(
      String leagueId);
  Future<Either<Failure, List<LeagueSurvivorRoundsEntity>>>
      fetchLeagueSurvivorRounds(String leagueId);
  Future<Either<Failure, List<LeagueSummary>>> fetchUserLeagues(); // New method
}
