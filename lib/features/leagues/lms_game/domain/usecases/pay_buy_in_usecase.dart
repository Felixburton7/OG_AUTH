// pay_buy_in_usecase.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';

@injectable
class PayBuyInUseCase {
  final ManageLeaguesRepository repository;

  PayBuyInUseCase(this.repository);

  /// Returns [Either<Failure, bool>]
  /// - [Right(true)] if payment succeeded
  /// - [Left(Failure(errorMessage))] if it failed
  Future<Either<Failure, bool>> execute(String leagueId) async {
    try {
      // Simply call the repository method
      await repository.payBuyIn(leagueId);

      // If no exception is thrown, payment succeeded
      return const Right(true);
    } on Exception catch (e) {
      // Convert the caught exception into a Failure
      // For instance, if repository throws `Exception('Insufficient funds')`
      // this will return `Left(Failure('Insufficient funds'))`
      return Left(Failure(e.toString()));
    }
  }
}
