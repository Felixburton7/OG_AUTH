import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/account/settings/theme_mode/domain/repository/theme_mode_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrSetInitialThemeModeUseCase
    extends SyncUseCase<int, GetOrSetInitialThemeModeUseCaseParams> {
  GetOrSetInitialThemeModeUseCase(
    this._themeModeRepository,
  );

  final ThemeModeRepository _themeModeRepository;

  @override
  Either<Failure, int> execute(GetOrSetInitialThemeModeUseCaseParams params) {
    try {
      final result = _themeModeRepository.getOrSetInitialThemeModeIndex(
        params.currentThemeModeId,
      );
      return Right(result); // Return success case with Right
    } catch (e) {
      return Left(Failure()); // Return failure case with Left
    }
  }
}

// The parameters expected to be put into the use case
class GetOrSetInitialThemeModeUseCaseParams extends Equatable {
  const GetOrSetInitialThemeModeUseCaseParams({
    required this.currentThemeModeId,
  });

  final int currentThemeModeId;

  @override
  List<Object?> get props => [currentThemeModeId];
}
