import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/account/settings/theme_mode/domain/repository/theme_mode_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetThemeModeUseCase extends UseCase<void, SetThemeModeUseCaseParams> {
  SetThemeModeUseCase(this._themeModeRepository);

  final ThemeModeRepository _themeModeRepository;

  @override
  Future<Either<Failure, void>> execute(
      SetThemeModeUseCaseParams params) async {
    try {
      _themeModeRepository.setThemeMode(params.themeModeIndex);
      return const Right(null); // Return success (Right with void)
    } catch (e) {
      return Left(Failure()); // Return failure case
    }
  }
}

class SetThemeModeUseCaseParams extends Equatable {
  const SetThemeModeUseCaseParams({
    required this.themeModeIndex,
  });

  final int themeModeIndex;

  @override
  List<Object?> get props => [themeModeIndex];
}
