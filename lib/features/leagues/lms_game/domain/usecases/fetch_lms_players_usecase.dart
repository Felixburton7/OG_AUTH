// import 'package:fpdart/fpdart.dart';
// import 'package:injectable/injectable.dart';
// import 'package:panna_app/core/error/failures.dart';
// import 'package:panna_app/core/use_cases/use_case.dart';
// import 'package:panna_app/features/leagues/all_leagues/domain/repositories/all_leagues_repository.dart';
// import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
// import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_players.dart';
// import 'package:panna_app/features/leagues/lms_game/domain/repository/lms_game_repository.dart';

// @injectable
// class FetchLmsPlayersUseCase
//     implements UseCase<List<LmsPlayersEntity>, String> {
//   final LmsGameRepository repository;

//   FetchLmsPlayersUseCase(this.repository);

//   @override
//   Future<Either<Failure, List<LmsPlayersEntity>>> execute(
//       String leagueId) async {
//     try {
//       final result = await repository.fetchLmsPlayers(leagueId);
//       return result;
//     } catch (e) {
//       return Left(
//           Failure('Failed to fetch league members')); // Handle failure case
//     }
//   }
// }
